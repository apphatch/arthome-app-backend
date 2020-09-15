module Mappers
  class OsaWeekendExportMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        shop.try(:importing_id),
        shop.try(:name),
        stock.try(:barcode),
        stock.try(:name),
        stock.try(:sku),
        stock.try(:category),
        checklist_item.data["Result"],
      ]
    end
  end
end
