module Mappers
  class SosExportMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        shop.try(:importing_id),
        shop.try(:name),
        stock.try(:name),
        stock.try(:sub_category),
        checklist_item.data["Length of Unilever"],
        checklist_item.data["Length of Competitor"],
      ]
    end
  end
end
