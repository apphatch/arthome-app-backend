class ChecklistItemSerializer < ActiveModel::Serializer
  attributes :id, :data, :stock_name, :category, :sub_category, :mechanic, :quantity, :barcode

  def stock_name
    object.stock.name
  end

  def barcode
    object.stock.barcode
  end

  def category
    object.stock.try(:category)
  end

  def sub_category
    object.stock.try(:sub_category)
  end
end
