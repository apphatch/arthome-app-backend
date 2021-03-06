require 'base64'
class ShopsController < ApplicationController
  def index
    render json: Shop.active.where(
      app_group: @current_app.get(:app_group)
    ).order(:name), each_serializer: ShopSerializer, **serializer_options
  end

  def index_by_user
    if current_user.present?
      render json: current_user.shops.active.where(
        app_group: @current_app.get(:app_group)
      ).sort_by(&:name), each_serializer: ShopSerializer, **serializer_options
    else
      head 400
    end
  end

  def show
    find_record do |shop|
      render json: shop, serializer: ShopSerializer, **serializer_options
    end
  end

  def create
    shop = Shop.create shop_params
    render json: shop, serializer: ShopSerializer, **serializer_options
  end

  def update
    find_record do |shop|
      shop.update shop_params
      render json: shop, serializer: ShopSerializer, **serializer_options
    end
  end

  def destroy
    find_record do |shop|
      shop.deleted!
      render json: shop, serializer: ShopSerializer, **serializer_options
    end
  end

  def checkin
    find_record do |shop|
      if current_user.present?
        record = current_user.checkin shop, permitted_params
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
        record = current_user.checkout shop, permitted_params
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
        record = shop.checkout current_user, permitted_params
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
      render json: shops.order(:name), each_serializer: ShopSerializer, **serializer_options and return if shops.present?
    end

    render json: []
  end

  def permitted_params
    super params.permit(
      :app, :app_group, :photo, :note, :time, :photo_name,
      :incomplete, :longitude, :latitude, :photos => []
    )
  end

  def shop_params
    super params.permit(
      :app_group, :name, :importing_id, :full_address,
      :shop_type, :longitude, :latitude
    )
  end

  def serializer_options
    return {
      current_user: @current_user
    }
  end

  def find_record
    shop = Shop.active.find_by_id params[:id]
    if shop.present?
      yield shop
    else
      head 404
    end
  end
end
