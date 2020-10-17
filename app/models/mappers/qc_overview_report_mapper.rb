module Mappers
  class QcOverviewReportMapper < BaseMapper
    def self.apply_each checklist
      stats = Reducers::QcOverviewReportReducer.reduce checklist.checklist_items
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
