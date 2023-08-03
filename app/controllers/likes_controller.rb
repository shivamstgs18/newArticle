class LikesController < ApplicationController

  before_action :require_login

  def create
    @article = Article.find(params[:article_id])
    @like = current_user.likes.build(article: @article)

    if @like.save
      redirect_to @article, notice: 'Article liked successfully.'
    else
      redirect_to @article, alert: 'Failed to like the article.'
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    redirect_to @like.article, notice: 'Article unliked successfully.'
  end

  private

  def require_login
    redirect_to login_path, alert: 'Please log in to perform this action.' unless current_user
  end
end
