module Mappers
  class RentalExportMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        shop.try(:importing_id),
        shop.try(:name),
        stock.try(:name),
        stock.try(:rental_type),
        stock.try(:category),
        checklist_item.data["Available"],
        checklist_item.data["Inline"],
        checklist_item.data["Png"],
      ]
    end
  end
end
