class ApplicationController < ActionController::Base
  before_action :check_user_is_logged_in
  before_action :set_csrf_token_for_api
  protect_from_forgery with: :exception

  def auth_info
    if params[:auth_token].present?
      return JsonWebToken.decode params[:auth_token]
    else
      return nil
    end
  end

  def current_user
    @current_user = nil

    if params[:auth_token].present?
      @current_user ||= User.active.find_by_jwt @params[:auth_token]
    end

    return @current_user
  end

  def check_user_is_logged_in
    head 401 and return unless current_user.present?

    if Time.zone.at(auth_info[:expires_at]) < Time.current
      redirect_to controller: 'sessions', action: 'destroy'
    end
  end

  private
  def set_csrf_token_for_api
    response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-CSRF-Token'])
  end
end
