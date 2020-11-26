module Mappers
  class PromotionsExportMapper < BaseMapper
    def apply_each checklist_item
      return nil if checklist_item.data.empty?
      user = checklist_item.checklist.try(:user)
      shop = checklist_item.checklist.try(:shop)
      stock = checklist_item.stock
      return [
        @locale.adjust_for_timezone(
          checklist_item.updated_at
        ).strftime('%d%m%Y'),
        shop.try(:importing_id),
        shop.try(:name),
        stock.try(:name),
        stock.try(:barcode),
        stock.try(:sku),
        checklist_item.quantity,
        checklist_item.data["Available"],
        checklist_item.data["Void"],
        checklist_item.data["Promotion"],
        user.try(:importing_id),
        checklist_item.mechanic,
        checklist_item.data["Note"],
      ]
    end
  end
end
