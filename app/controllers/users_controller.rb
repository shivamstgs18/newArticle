class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]


  def show
    @articles = @user.articles
    render json: { user: @user, articles: @articles }
  end


  def index
    @users = User.all
    render json: @users
  end


  def new
    @user = User.new
    render json: @user
  end


  def edit
    render json: @user
  end


  def update
    if @user.update(user_params)
      render json: @user, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
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
