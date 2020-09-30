module AttributeAliases::QcShop
  extend ActiveSupport::Concern

  def npp
    self.custom_attributes[:distributor]
  end

  def store_type
    self.custom_attributes[:shop_type_2]
  end
end
