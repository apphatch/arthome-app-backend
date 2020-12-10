module Reports
  class QcOverviewReport < BaseReport
    def initialize params={}
      super params
    end

    def generate
      set_headers [
        'Tên nhân viên', 'Tên cửa hàng', 'Địa chỉ', 'HPC', 'IC',
        'HPC thực', 'IC thực', 'Xanh', 'Vàng', 'Đỏ'
      ]

      checklists = Checklist.active.where(checklist_type: 'qc')

      mapper = Mappers::QcOverviewReportMapper.new locale: @locale
      set_data mapper.map(checklists).compact

      super
    end
  end
end
