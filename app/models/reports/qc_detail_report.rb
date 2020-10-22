module Reports
  class QcDetailReport < BaseReport
    def initialize params={}
      super params
    end

    def generate
      set_headers [
        'Ngày', 'Nhân viên', 'Cửa hàng', 'Địa chỉ', 'SKU' ,'Mức cảnh báo', 'Lỗi', 'Hình ảnh'
      ]

      checklists = Checklist.where checklist_type: 'qc', date: @date_from..@date_to

      checklist_items = checklists.present? ? checklists.collect{|c| c.checklist_items}.flatten : []
      set_data Mappers::QcDetailReportMapper.map checklist_items

      data = []
      @data.each do |entry|
        data += entry
      end

      return [@headers] + data
    end
  end
end
