require 'base64'
class StocksController < ApplicationController
  def index
    render json: Stock.active.order(:name), each_serializer: StockSerializer
  end

  def index_by_shop
    shop = Shop.active.find_by_id params[:shop_id]
    if shop.present?
      render json: shop.stocks.order(:name), each_serializer: StockSerializer
    else
      head 404
    end
  end

  def show
    find_record do |stock|
      render json: stock, serializer: StockSerializer
    end
  end

  def create
    stock = Stock.create permitted_params
    render json: stock, serializer: StockSerializer
  end

  def update
    find_record do |stock|
      stock.update permitted_params
      render json: stock, serializer: StockSerializer
    end
  end

  def destroy
    find_record do |stock|
      stock.deleted!
      render json: stock, serializer: StockSerializer
    end
  end

  def search
    ['name', 'sku', 'barcode', 'category', 'role'].each do |attr|
      result = Stock.active.where(
        "#{attr} ILIKE :term", term: "%#{params[:search_term]}%"
      )
      render json: result.order(:name), each_serializer: StockSerializer and return if result.present?
    end
    head 404
  end

  def import
    begin
      # assume only 1 file
      f = params[:files].first
      importer = @current_app.get(:stock_importer).new(file: f.path())
      importer.import
      head 201
    rescue
      head 500
    end
  end

  def import_template
    data = @current_app.get(:stock_importer).template
    data = @current_app.get(:stock_importer).template_rental if params[:rental]
    f = File.open 'export/import-template.xls', 'rb'
    enc = Base64.encode64 f.read
    send_data enc, type: :xls, filename: 'stock-import-template.xls'
  end

  def permitted_params
    return params.permit(:files)
  end

  def find_record
    stock = Stock.active.find_by_id params[:id]
    if stock.present?
      yield stock
    else
      head 404
    end
  end
end
