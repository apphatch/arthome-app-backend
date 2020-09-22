class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :importing_id, :shop_type,
    :full_address, :city, :district, :completed

  def completed
    #HACK
    begin
      return object.completed? @instance_options[:app], @instance_options[:user]
    rescue
      return false
    end
  end
end
