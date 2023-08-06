class LikesController < ApplicationController
  # before_action :require_login

  def index
    @article = Article.find(params[:article_id])
    @likes = @article.likes
    render json: @likes
  end

  def create
    @article = Article.find(params[:article_id])
    @like = current_user.likes.build(article: @article)

    respond_to do |format|
      if @like.save
        format.html { redirect_to @article, notice: 'Article liked successfully.' }
        format.json { render json: { message: 'Article liked successfully.' } }
      else
        format.html { redirect_to @article, alert: 'Failed to like the article.' }
        format.json { render json: { error: 'Failed to like the article.' }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to @like.article, notice: 'Article unliked successfully.' }
      format.json { render json: { message: 'Article unliked successfully.' } }
    end
  end

  private

  def require_login
    respond_to do |format|
      format.html { redirect_to login_path, alert: 'Please log in to perform this action.' unless current_user }
      format.json { render json: { error: 'Please log in to perform this action.' }, status: :unauthorized unless current_user }
    end
  end
end
