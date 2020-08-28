module Mappers
  class OosExportMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        shop.try(:importing_id),
        shop.try(:name),
        checklist_item.stock.try(:category),
        stock.try(:sku),
        stock.try(:name),
        stock.try(:barcode),
        checklist_item.quantity,
        checklist_item.data[:available],
        checklist_item.data[:void],
        checklist_item.data[:note],
      ]
    end
  end
end
