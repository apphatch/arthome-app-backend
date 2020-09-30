module AttributeAliasable::QcStock
  extend ActiveSupport::Concern

  def role_shop
    self.custom_attributes[:role_shop]
  end
end
