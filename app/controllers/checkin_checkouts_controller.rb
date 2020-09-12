class CheckinCheckoutsController < ApplicationController
  def index
    @records = CheckinCheckout.user.active
    @records = @records.filter{|c| c.checkin?} if @current_app == 'osa-webportal'
    render json: @records, each_serializer: CheckinCheckoutSerializer
  end

  def index_shop
    @records = CheckinCheckout.shop.active
    render json: @records, each_serializer: CheckinCheckoutSerializer
  end

  def show
    find_record do |record|
      render json: record, serializer: CheckinCheckoutSerializer
    end
  end

  def create
    record = CheckinCheckout.create permitted_params
    render json: record, serializer: CheckinCheckoutSerializer
  end

  def update
    find_record do |record|
      record.update permitted_params
      render json: record, serializer: CheckinCheckoutSerializer
    end
  end

  def destroy
    find_record do |record|
      record.deleted!
      render json: record, serializer: CheckinCheckoutSerializer
    end
  end

  def permitted_params
    return params
  end

  def find_record
    record = CheckinCheckout.active.find_by_id params[:id]
    if record.present?
      yield record
    else
      head 404
    end
  end
end
