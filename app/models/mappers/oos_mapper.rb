module Mappers
  class OosMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return {
        outlet_code: shop.try(:importing_id),
        outlet_name: shop.try(:name),
        category: checklist_item.stock.try(:category),
        ulv_code: stock.try(:sku),
        vn_descriptions: stock.try(:name),
        barcode: stock.try(:barcode),
        stock: checklist_item.quantity,
        available: checklist_item.data[:available],
        void: checklist_item.data[:void],
        note: checklist_item.data[:note],
      }
    end
  end
end
