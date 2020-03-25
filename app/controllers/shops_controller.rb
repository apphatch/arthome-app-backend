class ShopsController < ApplicationController
  def index
    render json: Shop.all.where(deleted: false)
  end

  def show
    find_record do |shop|
      render json: shop
    end
  end

  def create
    shop = Shop.create permitted_params
    render json: shop
  end

  def update
    find_record do |shop|
      shop.update = permitted_params
      render json: shop
    end
  end

  def destroy
    find_record do |shop|
      shop.deleted!
      render json: shop
    end
  end

  def checkin
    find_record do |shop|
      if current_user.present?
        record = shop.checkin current_user, params
        if record.present?
          render json: record
        else
          head 400
        end
      end
    end
  end

  def checkout
    find_record do |shop|
      if current_user.present?
        record = shop.checkout current_user, params
        if record.present?
          render json: record
        else
          head 400
        end
      end
    end
  end

  def permitted_params
    return params
  end

  def find_record
    shop = Shop.find_by_id params[:id]
    if shop.present?
      yield shop
    else
      head 404
    end
  end
end
