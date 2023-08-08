class ApplicationController < ActionController::API
  before_action :require_login, except: :home

  def current_user
    @current_user ||= User.find_by(id: decoded_token['user_id']) if decoded_token
  end

  def logged_in?
    !!current_user
  end

  private

  def require_login
    render json: { error: 'Please log in to perform this action.'}, status: :unauthorized unless logged_in?
  end

  def decoded_token
    if authorization_header
      token = authorization_header.split(' ')[1]
      begin
        JWT.decode(token,Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')[0]
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorization_header
    request.headers['Authorization']
  end
end
