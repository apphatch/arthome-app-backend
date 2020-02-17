class ChecklistsController < ApplicationController
  def index
    render json: Checklist.all.where(deleted: false)
  end

  def show
    find_record do |checklist|
      render json: checklist
    end
  end

  def create
    checklist = Checklist.create permitted_params
    render json: checklist
  end

  def update
    find_record do |checklist|
      checklist.update_attributes = permitted_params
      render json: checklist
    end
  end

  def destroy
    find_record do |checklist|
      checklist.deleted!
      render json: checklist
    end
  end

  def permitted_params
    return params
  end

  def find_record
    checklist = Checklist.find_by_id params[:id]
    if checklist.present?
      yield checklist
    else
      render json: {'error': 'not found'}
    end
  end
end
