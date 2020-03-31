class ShopsController < ApplicationController
  def index
    render json: Shop.all.where(deleted: false)
  end

  def index_by_user
    if current_user.present?
      render json: current_user.shops
    else
      head 400
    end
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
      shop.update permitted_params
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
          render json: current_user.last_checkin_checkout
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
          render json: current_user.last_checkin_checkout
        end
      end
    end
  end

  def search
    ['name', 'full_address'].each do |attr|
      result = Shop.where(
        "#{attr} ILIKE :term", term: "%#{params[:search_term]}%"
      )
      render json: result and return if result.present?
    end
    head 404
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
