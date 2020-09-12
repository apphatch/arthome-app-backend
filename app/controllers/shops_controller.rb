require 'base64'
class ShopsController < ApplicationController
  def index
    render json: Shop.active.order(:name), each_serializer: ShopSerializer, user: current_user
  end

  def index_by_user
    if current_user.present?
      render json: current_user.shops.active.sort_by(&:name), each_serializer: ShopSerializer, user: current_user
    else
      head 400
    end
  end

  def show
    find_record do |shop|
      render json: shop, serializer: ShopSerializer, user: current_user
    end
  end

  def create
    shop = Shop.create permitted_params
    render json: shop, serializer: ShopSerializer, user: current_user
  end

  def update
    find_record do |shop|
      shop.update permitted_params
      render json: shop, serializer: ShopSerializer, user: current_user
    end
  end

  def destroy
    find_record do |shop|
      shop.deleted!
      render json: shop, serializer: ShopSerializer, user: current_user
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
      render json: shops.order(:name), serializer: ShopSerializer, user: current_user and return if shops.present?
    end

    render json: []
  end

  def import_template
    data = Importers::OsaShopsImporter.template if @current_app.name == 'osa-webportal'
    data = Importers::QcShopsImporter.template if @current_app.name == 'qc'

    f = File.open 'export/import-template.xls', 'rb'
    enc = Base64.encode64 f.read
    send_data enc, type: :xls, filename: 'shop-import-template.xls'
  end

  def import_osa
    begin
      # assume only 1 file
      f = params[:files].first
      importer = Importers::OsaMasterImporter.new file: f
      importer.import
      head 201
    rescue
      head 500
    end
  end

  def permitted_params
    return params.permit(
      :photo, :note, :time, :photo_name, :incomplete,
      :photos => []
    )
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
