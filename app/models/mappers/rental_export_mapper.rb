module Mappers
  class RentalExportMapper < BaseMapper
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
        stock.try(:sub_category),
        stock.try(:rental_type),
        checklist_item.data["Available"],
        checklist_item.data["Void"],
        checklist_item.data["Inline"],
        checklist_item.data["Png"],
        user.try(:importing_id)
      ]
    end
  end
end
