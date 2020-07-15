class ChecklistItemSerializer < ActiveModel::Serializer
  attributes :id, :data, :stock_name, :category

  def stock_name
    object.stock.name
  end

  def category
    object.stock.try(:category)
  end
end
