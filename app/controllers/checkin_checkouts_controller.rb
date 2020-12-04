class CheckinCheckoutsController < ApplicationController
  def index
    @records = CheckinCheckout.user.active
    #TODO: refac this into model, it has no business being here
    if @current_app.name == 'osa-webportal'
      @records = @records.where("created_at >= ?", DateTime.parse(params[:date_from])) if params[:date_from]
      @records = @records.where("created_at <= ?", DateTime.parse(params[:date_to])) if params[:date_to]
      @records = @records.today.filter{|c| c.checkin?} unless (params[:date_from].present? || params[:date_to].present?)
    end
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
