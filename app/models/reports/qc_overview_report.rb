module Reports
  class QcOverviewReport < BaseReport
    def generate
      checklists = Checklist.where checklist_type: 'qc'
      return Mappers::QcOverviewReportMapper.map checklists
    end
  end
end
