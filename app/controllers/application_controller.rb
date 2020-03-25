class ApplicationController < ActionController::Base
  before_action :check_user_is_logged_in
  before_action :set_csrf_token_for_api
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id].present?
      @current_user ||= User.find_by_id session[:user_id]
    else
      @current_user = nil
    end
    return @current_user
  end

  def check_user_is_logged_in
    unless current_user.present?
      render json: {error: 'please login'} and return
    end
  end

  private
  def set_csrf_token_for_api
    response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-CSRF-Token']
  end
end
