class StocksController < ApplicationController
  def index
    render json: Stock.all.where(deleted: false)
  end

  def index_by_shop
    shop = Shop.find_by_id params[:shop_id]
    if shop.present?
      render json: shop.stocks
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
      stock.update = permitted_params
      render json: stock
    end
  end

  def destroy
    find_record do |stock|
      stock.deleted!
      render json: stock
    end
  end

  def permitted_params
    return params
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
