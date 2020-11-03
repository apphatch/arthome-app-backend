class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :importing_id, :shop_type,
    :full_address, :city, :district, :completed

  def completed
    return object.completed? @instance_options[:current_user]
  end
end
