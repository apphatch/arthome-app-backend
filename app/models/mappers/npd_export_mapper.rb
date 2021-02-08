module Mappers
  class NpdExportMapper < BaseMapper
    def apply_each checklist_item
      return nil if checklist_item.data.empty?
      user = checklist_item.checklist.try(:user)
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        @locale.adjust_for_timezone(
          checklist_item.updated_at
        ),
        shop.try(:importing_id),
        shop.try(:name),
        checklist_item.stock.try(:category),
        stock.try(:name),
        stock.try(:barcode),
        stock.try(:sku),
        checklist_item.quantity,
        checklist_item.data["Available"],
        checklist_item.data["Void"],
        user.try(:importing_id),
        checklist_item.data["Note"],
      ]
    end
  end
end
