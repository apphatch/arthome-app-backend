class ApplicationController < ActionController::Base
  include Permissible
  #disallow sym_roles; return if performed?
  #allow sym_roles; return if performed?

  #we're using apis only for now so this isn't necessary
  skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :exception

  before_action :check_user_is_logged_in
  before_action :set_app

  def auth_info
    if request.headers['Authorization'].present?
      return JsonWebToken.decode request.headers['Authorization']
    end
    return nil
  end

  def current_user
    if request.headers['Authorization'].present?
      @current_user ||= User.find_by jwt: request.headers['Authorization']
    end

    return @current_user
  end

  def set_app
    head 404 and return unless request.headers['App'].present?
    @current_app = AppRouters::BaseFactory.make request.headers['App'].downcase
  end

  def check_user_is_logged_in
    @current_user = nil

    head 401 and return unless current_user.present?
    head 401 and return if auth_info.nil?

    if Time.zone.at(auth_info[:exp]) < Time.current
      redirect_to controller: 'sessions', action: 'destroy'
    end

    set_jwt_for_api current_user
  end

  private
  def set_jwt_for_api user
    token = JsonWebToken.encode user_id: user.id, exp: 24.hours.from_now
    user.update jwt: token
    response.headers['Authorization'] = token
    return token
  end

  def permitted_params p
    return {} unless p.present? && p.instance_of?(ActionController::Parameters)
    p = p.to_h.merge(
      app: @current_app.get(:app),
      app_group: @current_app.get(:app_group),
    )
    p = p.merge(
      locale: Locality::BaseLocality.make(@current_user.locale)
    ) if @current_user.present?
    return p
  end
end
