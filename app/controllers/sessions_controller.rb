class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  skip_before_action :check_user_is_logged_in, only: [:create, :destroy]

  def new
  end

  def create
    if session[:user_id].present?
      render json: {result: 'already logged in'} and return
    end

    user = User.find_by_username params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:expires_at] = Time.current.+ 15.minutes
      render json: {result: 'logged in'} and return
    else
      head 401
    end
  end

  def destroy
    reset_session
  end
end
