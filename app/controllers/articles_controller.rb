# app/controllers/articles_controller.rb

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  skip_before_action :set_article, only: [:top_posts]

  def show
    @article.increment_views

    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @article.to_json(methods: :reading_time) }
    end
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

    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @articles.to_json(methods: :reading_time) }
    end
  end

  def top_posts
    @top_posts = Article.order(popularity_score: :desc).limit(10)
    respond_to do |format|
      format.json { render json: @top_posts.to_json(methods: :reading_time) }
    end
  end

  def new
    @article = Article.new
    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @article, methods: :reading_time }
    end
  end

  def edit
    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @article, methods: :reading_time }
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

  def similar_user_articles
    @article = Article.find(params[:id])
    user_id = @article.user_id
    @similar_articles = Article.where.not(id: @article.id, user_id: user_id).limit(5)

    respond_to do |format|
      format.html # This will be handled later or can be removed if not required
      format.json { render json: @similar_articles.to_json(methods: :reading_time) }
    end
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
