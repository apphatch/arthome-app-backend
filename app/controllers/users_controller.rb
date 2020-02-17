class UsersController < ApplicationController
  def index
    render json: User.all.where(deleted: false)
  end

  def show
    find_record do |user|
      render json: user
    end
  end

  def create
    user = User.create permitted_params
    render json: user
  end

  def update
    find_record do |user|
      user.update_attributes = permitted_params
      render json: user
    end
  end

  def destroy
    find_record do |user|
      user.deleted!
      render json: user
    end
  end

  def permitted_params
    return params
  end

  def find_record
    user = User.find_by_id params[:id]
    if user.present?
      yield user
    else
      render json: {'error': 'not found'}
    end
  end
end
