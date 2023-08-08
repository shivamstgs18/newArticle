class CommentsController < ApplicationController
  before_action :set_article
  before_action :authenticate_user!


  def index
    @comments = @article.comments
    render json: @comments
  end


  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user


    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end


  def show
    @comment = @article.comments.find(params[:id])
    render json: @comment
  end


  def update
    @comment = @article.comments.find(params[:id])


    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end


  def destroy
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    head :no_content
  end


  private


  def set_article
    @article = Article.find(params[:article_id])
  end


  def comment_params
    params.require(:comment).permit(:body)
  end
end
