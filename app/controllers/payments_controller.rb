class PaymentsController < ApplicationController
  before_action :require_login

  def revenue
    article_limit = params[:article_limit].to_i
    total_revenue = calculate_revenue(article_limit)
    render json: { revenue: total_revenue }
  end

  def distribute
    total_revenue = params[:total_revenue].to_f
    distribute_revenue(total_revenue)
    render json: { message: 'Revenue distributed successfully.' }
  end

  private

  def calculate_revenue(article_limit)
    articles = Article.all.limit(article_limit)
    total_revenue = articles.sum(&:revenue)
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
