module Reports
  class QcDetailReport < BaseReport
    def initialize params={}
      super params
    end

    def generate
      set_headers [
        'Ngày', 'Nhân viên', 'Cửa hàng', 'Địa chỉ', 'SKU' ,'Mức cảnh báo', 'Lỗi', 'Hình ảnh'
      ]

      checklist_items = ChecklistItem.active.where(app_group: 'qc').collect{|c| c if (
          c.data != {} &&
          c.updated_at.between?(@date_from, @date_to)
        )
      }.compact
      set_data Mappers::QcDetailReportMapper.map checklist_items

      data = []
      @data.each do |entry|
        data += entry
      end

      return [@headers] + data
    end
  end
end
