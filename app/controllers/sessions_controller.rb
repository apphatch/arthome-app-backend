class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :new]
  skip_before_action :check_user_is_logged_in, only: [:create, :destroy]

  def new
  end

  def create
    if session[:user_id].present? && false
      # try jwt
      render json: {result: 'already logged in', user_id: session[:user_id]} and return
    end

    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      jwt = JsonWebToken.encode(user_id: user.id)
      session[:user_id] = user.id
      session[:expires_at] = Time.current + 30.minutes
      render json: {
        result: 'logged in', user_id: user.id, auth_token: jwt,
        last_checkin_checkout: user.last_checkin_checkout
      } and return
    else
      head 401
    end
  end

  def destroy
    session[:user_id] = nil
    #reset_session
    head 401
  end
end
