module Mappers
  class PromotionsExportMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        shop.try(:importing_id),
        shop.try(:name),
        stock.try(:barcode),
        stock.try(:name),
        stock.try(:sku),
        stock.try(:sub_category),
        checklist_item.mechanic,
        checklist_item.quantity,
        checklist_item.data["Available"],
        checklist_item.data["Void"],
        checklist_item.data["Promotion"],
        checklist_item.data["Note"],
      ]
    end
  end
end
