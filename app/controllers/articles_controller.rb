class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # ... (existing actions and methods)

  def show
    @article.increment_views

    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @article }
    end
  end

  def index
    if params[:search].present?
      @articles = search_articles(params[:search])
    else
      @articles = Article.all
    end

    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @articles }
    end
  end

  def new
    @article = Article.new
    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @article }
    end
  end

  def edit
    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @article }
    end
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was created successfully.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was updated successfully.' }
        format.json { render json: @article, status: :ok, location: @article }
      else
        format.html { render 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path }
      format.json { head :no_content }
    end
  end

  # ... (other methods, if any)

  private

  def set_article
    @article = Article.includes(:likes).find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :topic)
  end
end
