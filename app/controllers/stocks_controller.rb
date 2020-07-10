class StocksController < ApplicationController
  def index
    render json: Stock.all.where(deleted: false).order(:name)
  end

  def index_by_shop
    shop = Shop.find_by_id params[:shop_id]
    if shop.present?
      render json: shop.stocks.order(:name)
    else
      head 404
    end
  end

  def show
    find_record do |stock|
      render json: stock
    end
  end

  def create
    stock = Stock.create permitted_params
    render json: stock
  end

  def update
    find_record do |stock|
      stock.update permitted_params
      render json: stock
    end
  end

  def destroy
    find_record do |stock|
      stock.deleted!
      render json: stock
    end
  end

  def search
    ['name', 'sku', 'barcode', 'category', 'role'].each do |attr|
      result = Stock.where(
        "#{attr} ILIKE :term", term: "%#{params[:search_term]}%"
      )
      render json: result.order(:name) and return if result.present?
    end
    head 404
  end

  def import
    begin
      # assume only 1 file
      f = permitted_params[:files].first
      importer = Importers::StocksImporter.new file_name: f
      importer.import
      head 201
    rescue
      head 500
    end
  end

  def permitted_params
    return params.permit(:files)
  end

  def find_record
    stock = Stock.find_by_id params[:id]
    if stock.present?
      yield stock
    else
      head 404
    end
  end
end
