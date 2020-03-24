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
