require 'base64'

class ChecklistItemsController < ApplicationController
  def index
    render json: ChecklistItem.active
  end

  def index_by_checklist
    checklist = Checklist.active.find_by_id params[:checklist_id]
    if checklist.present?
      render json: checklist.checklist_items.active
    else
      head 404
    end
  end

  def show
    find_record do |checklist_item|
      render json: checklist_item
    end
  end

  def create
    checklist_item = ChecklistItem.create permitted_params
    render json: checklist_item
  end

  def update
    find_record do |checklist_item|
      checklist_item.update_data params[:data]
      render json: checklist_item, serializer: ChecklistItemSerializer
    end
  end

  def bulk_update
    ChecklistItem.bulk_update params[:checklist_items]
    head 201
  end

  def destroy
    find_record do |checklist_item|
      checklist_item.deleted!
      render json: checklist_item
    end
  end

  def permitted_params
    if ![
        params[:checklist_id], params[:stock_id]
    ].all?
      render json: {error: 'missing checklist_id or stock_id'} and return
    end
    params.permit!
    super params
  end

  def find_record
    checklist_item = ChecklistItem.find_by_id params[:id]
    if checklist_item.present?
      yield checklist_item
    else
      head 404
    end
  end
end
