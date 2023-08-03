class ArticlesController < ApplicationController

  def show
    @article=Article.includes(:likes).find(params[:id])
    @article.increment_views
  end

  def index
    if params[:search].present?
      @articles = search_articles(params[:search])
    else
      @articles = Article.all
    end
  end

  def new
    @article=Article.new
  end

  def edit
    @article=Article.find(params[:id])
  end

  def create
    @article= Article.new(params.require(:article).permit(:title, :description, :topic))
    @article.user=current_user
    if @article.save
      flash[:notice]="Article was created successfully."
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article=Article.find(params[:id])
    if @article.update(params.require(:article).permit(:title, :description, :topic))
      flash[:notice]="Article was updated succesfully"
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article=Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  def search
    if params[:search].present?
      @articles = search_articles(params[:search])
    else
      @articles = Article.all
    end
  end

  private

  def search_articles(search_params)
    search_query = "%#{search_params}%"
    Article.joins(:user).where(
      "LOWER(articles.title) LIKE ? OR LOWER(articles.topic) LIKE ? OR LOWER(users.username) LIKE ?",
      search_query.downcase, search_query.downcase, search_query.downcase
    )
  end

end