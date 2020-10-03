module Reducers
  class QcOverviewReportReducer < BaseReducer
    def self.apply_each checklist_item
      stats = [0, 0, 0]
      if checklist_item.data.present?
        records = checklist_item.data["records"]
        stats = records.collect{|r| r["Mức cảnh báo"]}.compact
        stats = [stats.count("Xanh"), stats.count("Vàng"), stats.count("Đỏ")]
      end
      return [
        checklist_item.stock.role == 'hpc' ? 1 : 0,
        checklist_item.stock.role == 'ic' ? 1 : 0,
      ] + stats
    end
  end
end
