module AttributeAliases::RentalStock
  def rental_type
    #change back to category
    #self.category
    self.sub_category
  end
end
