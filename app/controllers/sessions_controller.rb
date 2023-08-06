class SessionsController < ApplicationController
  #skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        format.html { redirect_to user, notice: 'Logged in successfully.' }
        format.json { render json: { message: 'Logged in successfully.' } }
      else
        format.html { flash.now[:alert] = 'There was something wrong with your login details.'; render 'new' }
        format.json { render json: { error: 'Invalid login credentials.' }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:user_id] = nil

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Logged out.' }
      format.json { render json: { message: 'Logged out successfully.' } }
    end
  end
end
