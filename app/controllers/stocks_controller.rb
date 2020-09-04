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
      importer = Importers::StocksImporter.new file: f
      importer.import
      head 201
    rescue
      head 500
    end
  end

  def template
    if @current_app == 'osa'
      data = Importers::OsaStocksImporter.template.string
      data = Importers::OsaStocksImporter.template_rental.string if params[:rental]
    end
    data = Importers::QcStocksImporter.template.string if @current_app == 'qc'
    send_data data, filename: 'stock-import-template.xlsx'
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
