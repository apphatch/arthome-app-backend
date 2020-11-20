module Mappers
  class SosExportMapper < BaseMapper
    def self.apply_each checklist_item
      return nil if checklist_item.data.empty?
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        shop.try(:importing_id),
        shop.try(:name),
        stock.try(:name),
        stock.try(:sub_category),
        checklist_item.data["Length of Unilever"],
        checklist_item.data["Length of Competitor"],
        @locale.adjust_for_timezone(
          checklist_item.updated_at
        ),
        checklist_item.data[:error]
      ]
    end
  end
end
