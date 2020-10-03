module Mappers
  class QcDetailReportMapper < BaseMapper
    def self.apply_each checklist
      shop = checklist_item.checklist.try(:shop)
      user = checklist_item.checklist.try(:user)
      stock = checklist_item.stock
      common = [
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
          entry["photo"].present? ? entry["photo"]["uri"] : "",
        ]
      end
    end
  end
end
