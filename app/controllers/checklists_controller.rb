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
      head 401
    end
  end

  def index_by_user
    if current_user.present?
      checklists = current_user.checklists.active
      checklists = checklists.collect{|c| c unless c.completed?}.compact
      render json: checklists, each_serializer: ChecklistSerializer
    else
      head 401
    end
  end

  def index_by_user_shop
    head 401 and return unless current_user.present?
    shop = current_user.shops.find_by_id params[:shop_id]
    head 401 and return unless shop.present?

    checklists = current_user.checklists.active.incompleted
    checklists = checklists.collect{|c| c if c.shop == shop}.compact
    render json: checklists, each_serializer: ChecklistSerializer
  end

  def show
    find_record do |checklist|
      render json: checklist, serializer: ChecklistSerializer
    end
  end

  def show_incomplete_items
    find_record do |checklist|
      render json: checklist.checklist_items.incompleted, each_serializer: ChecklistItemSerializer
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

  def search_checklist_items
    find_record do |checklist|
      result = checklist.checklist_items.select{ |item|
        item.stock.name.match(/#{params[:search_term]}/i)
      }
      if result.present?
        result = result.sort_by{|item| item.stock.name}
        render json: result, each_serializer: ChecklistItemSerializer and return
      end

      head 404
    end
  end

  def import
    begin
      # assume only 1 file
      f = params[:files].first
      importer = Importers::ChecklistsImporter.new file: f
      importer.import
      head 201
    rescue
      head 500
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
