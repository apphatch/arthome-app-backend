class ApplicationController < ActionController::Base
  include Permissible
  #disallow sym_roles; return if performed?
  #allow sym_roles; return if performed?

  #we're using apis only for now so this isn't necessary
  skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :exception

  before_action :set_current_app
  before_action :check_user_is_logged_in

  def auth_info
    if request.headers['Authorization'].present?
      return JsonWebToken.decode request.headers['Authorization']
    else
      return nil
    end
  end

  def current_user
    if request.headers['Authorization'].present?
      @current_user ||= User.find_by_jwt request.headers['Authorization']
    end

    return @current_user
  end

  def set_current_app
    head 404 and return unless request.headers['App'].present?
    @current_app = AppRouters::BaseFactory.make request.headers['App'].downcase
  end

  def check_user_is_logged_in
    @current_user = nil

    head 401 and return unless current_user.present?

    if Time.zone.at(auth_info[:exp]) < Time.current
      redirect_to controller: 'sessions', action: 'destroy'
    end

    set_jwt_for_api current_user
  end

  private
  def set_jwt_for_api user
    token = JsonWebToken.encode user_id: user.id, exp: 10.minutes.from_now
    user.update jwt: token
    response.headers['Authorization'] = token
    return token
  end
end
