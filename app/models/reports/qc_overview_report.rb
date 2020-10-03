module Reports
  class QcOverviewReport < BaseReport
    def generate
      set_headers [
        'Tên nhân viên', 'Tên cửa hàng', 'Địa chỉ', 'HPC', 'IC',
        'HPC thực', 'IC thực', 'Xanh', 'Vàng', 'Đỏ'
      ]

      set_data Mappers::QcOverviewReportMapper.map Checklist.where(checklist_type: 'qc')

      super
    end
  end
end
