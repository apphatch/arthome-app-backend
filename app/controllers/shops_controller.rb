class ShopsController < ApplicationController
  def index
    render json: Shop.active.order(:name)
  end

  def index_by_user
    if current_user.present?
      render json: current_user.active_shops.sort_by(&:name)
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
        record = shop.checkin current_user, permitted_params
        if record.present?
          render json: {status: 'success', last_checkin_checkout: record}
        else
          render json: {status: 'failed', last_checkin_checkout: current_user.last_checkin_checkout}
        end
      end
    end
  end

  def checkout
    find_record do |shop|
      if current_user.present?
        record = shop.checkout current_user, permitted_params
        if record.present?
          render json: {status: 'success', last_checkin_checkout: record}
        else
          render json: {status: 'failed', last_checkin_checkout: current_user.last_checkin_checkout}
        end
      end
    end
  end

  def shop_checkout
    find_record do |shop|
      if current_user.present?
        record = shop.shop_checkout current_user, permitted_params
        if record.present?
          render json: {status: 'success', last_checkin_checkout: record}
        else
          render json: {status: 'failed'}
        end
      end
    end
  end

  def search
    head 400 and return unless current_user.present?
    ['name', 'full_address'].each do |attr|
      shops = current_user.shops.active.where(
        "#{attr} ILIKE :term", term: "%#{params[:search_term]}%"
      )
      render json: shops.order(:name) and return if shops.present?
    end
    head 404
  end

  def permitted_params
    return params.permit(:photo, :note, :time, :photo_name)
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
