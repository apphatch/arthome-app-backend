class ChecklistItemSerializer < ActiveModel::Serializer
  attributes :id, :data, :stock_name

  def stock_name
    object.stock.name
  end
end
