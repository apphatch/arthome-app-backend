class ChecklistItemSerializer < ApplicationSerializer
  attributes :id, :data, :stock_name, :importing_id,
    :category, :sub_category, :mechanic, :quantity, :barcode,
    :rental_type, :photo, :role

  def importing_id
    object.stock.try(:importing_id)
  end

  def stock_name
    #TODO: refac this
    return object.stock.try(:sub_category) if object.checklist_type == 'sos'
    return object.stock.try(:name)
  end

  def barcode
    object.stock.try(:barcode)
  end

  def category
    object.stock.try(:category)
  end

  def sub_category
    return object.stock.try(:category) if object.checklist_type == 'sos'
    return object.stock.try(:sub_category)
  end

  def rental_type
    object.stock.try(:rental_type)
  end

  def role
    object.stock.try(:role)
  end
end
