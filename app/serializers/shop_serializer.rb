class ShopSerializer < ActiveModel::Serializer
  attributes :name, :importing_id, :shop_type, :full_address, :city, :district, :completed

  def completed
    object.completed?
  end
end
