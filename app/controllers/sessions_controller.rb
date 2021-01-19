class SessionsController < ApplicationController
  skip_before_action :set_app_info, only: [:destroy]
  skip_before_action :check_user_is_logged_in, only: [:create, :destroy]

  def new
  end

  def create
    # LOGIN
    app_group = @current_app.get(:app_group)
    user = User.active.with_app_group(app_group).find_by_username params[:username]
    head 404 unless user.present?
    head 401 unless user.failed_login_attempts < 5

    if user.authenticate(params[:password])
      user.update failed_login_attempts: 0
      set_jwt_for_api user
      render json: {
        result: 'logged in', user_id: user.id,
        last_checkin_checkout: user.last_checkin_checkout,
        shop: user.last_checkin_checkout.try(:shop)
      } and return
    else
      user.update failed_login_attempts: user.failed_login_attempts + 1
      head 401
    end
  end

  def destroy
    # LOGOUT
    current_user.update jwt: nil if current_user.present?
    head 200
  end

  def server_time
    return Time.current
  end
end
