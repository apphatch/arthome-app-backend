module Mappers
  class QcOverviewReportMapper < BaseMapper
    def apply_each checklist
      stats = Reducers::QcOverviewReportReducer.reduce checklist.checklist_items
      return nil if stats.sum.zero?
      return [
        checklist.try(:user).try(:name),
        checklist.try(:shop).try(:name),
        checklist.try(:shop).try(:full_address),
        252,
        36
      ] + stats
    end
  end
end
