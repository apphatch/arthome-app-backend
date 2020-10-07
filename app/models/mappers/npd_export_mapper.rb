module Mappers
  class NpdExportMapper < BaseMapper
    def self.apply_each checklist_item
      return nil if checklist_item.data.empty?
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
        checklist_item.updated_at
      ]
    end
  end
end
