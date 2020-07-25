class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :new]
  skip_before_action :check_user_is_logged_in, only: [:create, :destroy]

  def new
  end

  def create
    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      user.update jwt: token
      render json: {
        result: 'logged in', user_id: user.id, auth_token: token,
        last_checkin_checkout: user.last_checkin_checkout
      } and return
    else
      head 401
    end
  end

  def destroy
    current_user.update jwt: nil if current_user.present?
    head 401
  end
end
