module AttributeAliases::SosChecklistItem
  def sos_name
    self.sub_category
  end

  def sos_sub_category
    self.category
  end
end
