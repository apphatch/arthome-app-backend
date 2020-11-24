require 'base64'

class UsersController < ApplicationController
  def index
    allow :admin; return if performed?
    render json: User.active.order(:created_at)
  end

  def show
    allow :admin; return if performed?
    find_record do |user|
      render json: user
    end
  end

  def create
    user = User.create user_params
    render json: user
  end

  def update
    find_record do |user|
      user.update user_params
      render json: user
    end
  end

  def destroy
    find_record do |user|
      user.deleted!
      render json: user
    end
  end

  def lock
    find_record do |user|
      user.locked!
      render json: user
    end
  end

  def unlock
    find_record do |user|
      user.unlocked!
      render json: user
    end
  end

  def permitted_params
    return params.permit(:username, :name, :password, :importing_id, :app, :app_group)
  end

  def user_params
    return params.permit(:username, :name, :password, :importing_id, :app_group)
  end

  def find_record
    user = User.find_by_id params[:id]
    if user.present?
      yield user
    else
      head 404
    end
  end
end
