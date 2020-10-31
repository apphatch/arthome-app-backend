module AttributeAliasable::RentalStock
  extend ActiveSupport::Concern

  def rental_type
    self.sub_category
  end
end
