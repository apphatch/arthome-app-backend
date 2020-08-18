class ChecklistItemSerializer < ActiveModel::Serializer
  attributes :id, :data, :stock_name,
    :category, :sub_category, :mechanic, :quantity, :barcode,
    :rental_type

  def stock_name
    object.stock.try(:name)
  end

  def barcode
    object.stock.try(:barcode)
  end

  def category
    object.stock.try(:category)
  end

  def sub_category
    object.stock.try(:sub_category)
  end

  def rental_type
    object.stock.try(:rental_type)
  end
end
