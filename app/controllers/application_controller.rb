class ApplicationController < ActionController::Base
  include ActionController::Cookies
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  # skip_before_action :verify_authenticity_token # Allow JSON requests to bypass CSRF protection

  helper_method :current_user, :logged_in?
  # before_action :require_login, except: :home

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  private

  def require_login
    unless logged_in?
      respond_to do |format|
        format.html { 
          flash[:alert] = 'Please log in to perform this action.'
          redirect_to login_path
        }
        format.json { 
          render json: { error: 'Please log in to perform this action.' }, status: :unauthorized
        }
      end
    end
  end
end
