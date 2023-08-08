class PaymentsController < ApplicationController

  before_action :require_login
  require 'stripe'

  def create
    article_limit = params[:article_limit].to_i
    total_revenue = calculate_revenue(article_limit)

    intent = Stripe::PaymentIntent.create(
      amount: total_revenue,
      currency: 'usd'
    )

    render json: { client_secret: intent.client_secret }
  end

  def distribute
    total_revenue = params[:total_revenue].to_f
    distribute_revenue(total_revenue)
    render json: { message: 'Revenue distributed successfully.' }
  end

  private

  def calculate_revenue(article_limit)
    pricing_tiers = {
      1 => 0,
      3 => 3,
      5 => 5,
      10 => 10
    }
    applicable_tier = pricing_tiers.keys.select { |tier| tier <= article_limit }.max
    articles = Article.all.limit(applicable_tier)
    total_revenue = pricing_tiers[applicable_tier] * applicable_tier
    total_revenue
  end
  

  def distribute_revenue(total_revenue)
    viewed_articles = current_user.articles.where('created_at >= ?', Date.today)
    distribution_per_article = total_revenue / viewed_articles.size
    viewed_articles.each do |article|
      creator = article.user
      creator.update(revenue_earned: creator.revenue_earned + distribution_per_article)
    end
  end
end
