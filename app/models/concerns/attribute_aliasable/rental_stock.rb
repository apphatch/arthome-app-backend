module AttributeAliasable::RentalStock
  extend ActiveSupport::Concern

  def rental_type
    self.category
  end
end
