class ChecklistsController < ApplicationController
  def index
    render json: Checklist.all.where(deleted: false), each_serializer: ChecklistSerializer
  end

  def index_by_shop
    shop = Shop.find_by_id params[:shop_id]
    if shop.present?
      render json: shop.checklists
    else
      render json: {error: 'missing shop_id'} and return
    end
  end

  def index_by_user
    if current_user.present?
      render json: current_user.checklists
    else
      head 401
    end
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
      checklist.update = permitted_params
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
