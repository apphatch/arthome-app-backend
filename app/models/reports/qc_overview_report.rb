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

      checklists = Checklist.where(checklist_type: 'qc', updated_at: @date_from..@date_to).where.not(data: {})
      set_data Mappers::QcOverviewReportMapper.map checklists

      super
    end
  end
end
