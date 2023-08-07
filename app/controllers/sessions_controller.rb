class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      render json: { message: 'Logged in successfully.' }
    else
      render json: { error: 'Invalid login credentials.' }, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil

    render json: { message: 'Logged out successfully.' }
  end
end
