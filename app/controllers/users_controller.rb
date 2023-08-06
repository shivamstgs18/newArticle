class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @articles = @user.articles
    respond_to do |format|
      format.html 
      format.json { render json: { user: @user, articles: @articles } }
    end
  end

  def index
    @users = User.all
    respond_to do |format|
      format.html 
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Your account information was successfully updated.' }
        format.json { render json: @user, status: :ok, location: @user }
      else
        format.html { render 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to articles_path, notice: "Welcome to the article app, #{@user.username}, you are successfully signed up." }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
