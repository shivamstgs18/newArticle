class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :require_login, except: :home

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  private

  def require_login
    unless logged_in?
      render json: { error: 'Please log in to perform this action.' }, status: :unauthorized
    end
  end

  def authenticate_user!
    require_login
  end
end
