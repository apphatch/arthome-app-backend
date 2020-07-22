class CheckinCheckoutsController < ApplicationController
  def index
    @records = CheckinCheckout.all.where(deleted: false)
    render json: @records
  end

  def show
    find_record do |record|
      render json: record
    end
  end

  def create
    record = CheckinCheckout.create permitted_params
    render json: record
  end

  def update
    find_record do |record|
      record.update permitted_params
      render json: record
    end
  end

  def destroy
    find_record do |record|
      record.deleted!
      render json: record
    end
  end

  def permitted_params
    return params
  end

  def find_record
    record = CheckinCheckout.find_by_id params[:id]
    if record.present?
      yield record
    else
      head 404
    end
  end
end
