module Mappers
  class QcExportMapper < BaseMapper
    def apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      user = checklist_item.checklist.try(:user)
      stock = checklist_item.stock
      common = [
        @locale.adjust_for_timezone(
          checklist_item.updated_at,
        ),
        shop.try(:store_type),
        shop.try(:city),
        shop.try(:npp),
        shop.try(:name),
        shop.try(:full_address),
        user.try(:name),
        stock.custom_attributes[:uc],
        stock.custom_attributes[:packaging],
        stock.try(:category),
        stock.custom_attributes[:group],
        stock.try(:name),
        stock.try(:sku),
      ]
      return [common + ['']*7] if checklist_item.data.empty?
      return checklist_item.data["records"].collect do |entry|
        common + [
          entry["HSD"].present? ? entry["HSD"] : entry["NSX"],
          entry["Số lô"],
          entry["Lỗi"],
          entry["Mức cảnh báo"] == "Xanh" ? 1 : 0,
          entry["Mức cảnh báo"] == "Vàng" ? 1 : 0,
          entry["Mức cảnh báo"] == "Đỏ" ? 1 : 0,
          #HACK, fix asap
          (entry["photo_uri"].try(:strip).try(:empty?) ? "" : "http://13.228.52.25#{entry["photo_uri"]}")
        ]
      end
    end
  end
end
