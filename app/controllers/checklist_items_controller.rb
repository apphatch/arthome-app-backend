class ChecklistItemsController < ApplicationController
  def index
    render json: ChecklistItem.all.where(deleted: false)
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
      checklist_item.update = permitted_params
      render json: checklist_item
    end
  end

  def destroy
    find_record do |checklist_item|
      checklist_item.deleted!
      render json: checklist_item
    end
  end

  def permitted_params
    return params
  end

  def find_record
    checklist_item = ChecklistItem.find_by_id params[:id]
    if checklist_item.present?
      yield checklist_item
    else
      render json: {error: 'not found'}
    end
  end
end
