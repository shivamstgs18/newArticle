class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  skip_before_action :set_article, only: [:top_posts]


  def show
    @article.increment_views
    render json: @article.to_json(methods: :reading_time)
  end


  def index
    if params[:search].present?
      @articles = search_articles(params[:search])
    else
      @articles = Article.all
    end


    if params[:sort_by] == 'username'
      user = User.find_by(username: params[:username])
      @articles = @articles.where(user: user) if user
    end


    if params[:sort_by] == 'date'
      @articles = @articles.order(created_at: :desc)
    elsif params[:sort_by] == 'user'
      @articles = @articles.joins(:user).order('users.username')
    end


    render json: @articles.to_json(methods: :reading_time)
  end


  def top_posts
    @top_posts = Article.order(popularity_score: :desc).limit(10)
    render json: @top_posts.to_json(methods: :reading_time)
  end


  def new
    @article = Article.new
    render json: @article, methods: :reading_time
  end


  def edit
    render json: @article, methods: :reading_time
  end


  def create
    @article = Article.new(article_params)
    @article.user = current_user


    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end


  def update
    if @article.update(article_params)
      render json: @article, status: :ok, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end


  def destroy
    @article.destroy
    head :no_content
  end


  def similar_user_articles
    @article = Article.find(params[:id])
    user_id = @article.user_id
    @similar_articles = Article.where.not(id: @article.id, user_id: user_id).limit(5)
    render json: @similar_articles.to_json(methods: :reading_time)
  end


  def all_topics
    @topics = Article.pluck(:topic).uniq
    render json: @topics
  end


  private


  def set_article
    @article = Article.includes(:likes).find(params[:id])
  end


  def article_params
    params.require(:article).permit(:title, :description, :topic, :reading_time)
  end


  def search_articles(search_params)
    search_query = "%#{search_params}%"
    Article.joins(:user).where(
      "LOWER(articles.title) LIKE ? OR LOWER(articles.topic) LIKE ? OR LOWER(users.username) LIKE ?",
      search_query.downcase, search_query.downcase, search_query.downcase
    )
  end
 
end
