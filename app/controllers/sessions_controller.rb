class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :new]
  skip_before_action :check_user_is_logged_in, only: [:create, :destroy]
  skip_before_action :set_jwt_for_api, only: [:create, :destroy, :new]

  def new
  end

  def create
    # LOGIN
    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      set_jwt_for_api user
      render json: {
        result: 'logged in', user_id: user.id,
        last_checkin_checkout: user.last_checkin_checkout
      } and return
    else
      head 401
    end
  end

  def destroy
    # LOGOUT
    current_user.update jwt: nil if current_user.present?
    head 401
  end
end
