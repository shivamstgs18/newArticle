class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
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
      flash[:alert] = 'Please log in to perform this action.'
      redirect_to login_path
    end
  end
end
