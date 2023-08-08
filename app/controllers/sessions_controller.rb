class SessionsController < ApplicationController
  require 'jwt'
  skip_before_action :require_login, only: [:new, :create]


  def create
    user = User.find_by(email: params[:session][:email].downcase)


    if user && user.authenticate(params[:session][:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base, 'HS256')
      render json: { message: 'Logged in successfully.', token: token }
    else
      render json: { error: 'Invalid login credentials.' }, status: :unprocessable_entity
    end
  end
end
