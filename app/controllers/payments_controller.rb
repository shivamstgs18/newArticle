class PaymentsController < ApplicationController

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
    # Calculate revenue based on the article limit chosen by the user and the revenue from each article.
    # For simplicity, let's assume each article costs $1.

    articles = Article.all.limit(article_limit)
    total_revenue = articles.sum(&:revenue)

    total_revenue
  end

  def distribute_revenue(total_revenue)
    # Distribute revenue based on the popularity or views of the articles.
    # For simplicity, let's distribute the revenue equally among the creators of the articles.

    # Get all the articles viewed by the user in the current day
    viewed_articles = current_user.articles.where('created_at >= ?', Date.today)

    # Calculate the total revenue distribution amount per article
    distribution_per_article = total_revenue / viewed_articles.size

    # Distribute the revenue to the creators of the viewed articles
    viewed_articles.each do |article|
      creator = article.user
      creator.update(revenue_earned: creator.revenue_earned + distribution_per_article)
    end
  end
end
