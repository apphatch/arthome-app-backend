class ApplicationController < ActionController::Base
  before_action :check_user_is_logged_in
  before_action :set_csrf_token_for_api
  protect_from_forgery with: :exception

  def current_user
    @current_user = nil

    if session[:user_id].present?
      @current_user ||= User.active.find_by_id session[:user_id]
    end

    if params[:auth_token].present?
      @jwt_payload = JsonWebToken.decode(params[:auth_token])
      @current_user ||= User.active.find_by_id @jwt_payload[:user_id]
    end

    return @current_user
  end

  def check_user_is_logged_in
    head 401 and return unless current_user.present?
    if Time.zone.at(@jwt_payload[:expires_at]) < Time.current
      redirect_to controller: 'sessions', action: 'destroy'
    end
    # use jwt instead of sessions
    #if session[:expires_at] < Time.current
    #  redirect_to controller: 'sessions', action: 'destroy'
    #end
  end

  private
  def set_csrf_token_for_api
    response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
  end
end
