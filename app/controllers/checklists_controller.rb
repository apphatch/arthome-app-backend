class ChecklistsController < ApplicationController
  def index
    result = Checklist.active
    result = result.reject{|c| c.empty?} if params[:exclude_empty]
    result = result.reject{|c| c.completed?} if params[:exclude_completed]
    render json: result, each_serializer: ChecklistSerializer
  end

  def index_by_shop
    shop = Shop.find_by_id params[:shop_id]
    if shop.present?
      render json: shop.checklists.active, each_serializer: ChecklistSerializer
    else
      render json: {error: 'missing shop_id'} and return
    end
  end

  def index_by_user
    if current_user.present?
      render json: current_user.checklists.active, each_serializer: ChecklistSerializer
    else
      head 401
    end
  end

  def show
    find_record do |checklist|
      render json: checklist, serializer: ChecklistSerializer
    end
  end

  def show_incomplete_items
    find_record do |checklist|
      render json: checklist.incomplete_items, each_serializer: ChecklistItemSerializer
    end
  end

  def create
    checklist = Checklist.create permitted_params
    render json: checklist
  end

  def update
    find_record do |checklist|
      checklist.update params
      render json: checklist
    end
  end

  def update_checklist_items
    find_record do |checklist|
      checklist.update_checklist_items params
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
    if ![
        params[:user_id], params[:shop_id]
    ].all?
      render json: {error: 'missing user_id or shop_id'} and return
    end
    return params
  end

  def find_record
    checklist = Checklist.find_by_id params[:id]
    if checklist.present?
      yield checklist
    else
      head 404
    end
  end
end
