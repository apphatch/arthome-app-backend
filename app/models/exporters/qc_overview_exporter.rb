module Exporters
  class QcOverviewExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Tên nhân viên', 'Tên cửa hàng', 'Địa chỉ', 'HPC', 'IC',
        'HPC thực', 'IC thực', 'Xanh', 'Vàng', 'Đỏ'
      ]

      checklists = Checklist.active.where(checklist_type: 'qc')

      mapper = Mappers::QcOverviewReportMapper.new locale: @params[:locale]
      set_data mapper.map(checklists).compact

      super
    end
  end
end
