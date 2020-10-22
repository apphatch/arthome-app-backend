module Mappers
  class QcDetailReportMapper < BaseMapper
    def self.apply_each checklist_item
      shop = checklist_item.checklist.try(:shop)
      user = checklist_item.checklist.try(:user)
      stock = checklist_item.stock
      common = [
        checklist_item.updated_at.strftime('%d/%m/%Y'),
        user.try(:name),
        shop.try(:name),
        shop.try(:full_address),
        stock.try(:name),
      ]
      return [common + ['']*3] if checklist_item.data.empty?
      return checklist_item.data["records"].collect do |entry|
        common + [
          entry["Mức cảnh báo"],
          entry["Lỗi"],
          checklist_item.photo_with_path(entry["photo_uri"]).try(:image_path)
        ]
      end
    end
  end
end
