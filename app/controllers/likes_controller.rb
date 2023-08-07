class LikesController < ApplicationController
  before_action :require_login

  def index
    @article = Article.find(params[:article_id])
    @likes = @article.likes
    render json: @likes
  end

  def create
    @article = Article.find(params[:article_id])
    @like = current_user.likes.build(article: @article)

    if @like.save
      render json: { message: 'Article liked successfully.' }
    else
      render json: { error: 'Failed to like the article.' }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    render json: { message: 'Article unliked successfully.' }
  end

  private

  def require_login
    render json: { error: 'Please log in to perform this action.' }, status: :unauthorized unless current_user
  end
end
