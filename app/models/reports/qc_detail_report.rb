module Reports
  class QcDetailReport < BaseReport
    def generate
      set_headers [
        'Nhân viên', 'Cửa hàng', 'Địa chỉ', 'SKU' ,'Cảnh báo', 'Lỗi', 'Hình ảnh'
      ]

      checklists = Checklist.where(checklist_type: 'qc')
      checklist_items = checklists.present? ? checklists.collect{|c| c.checklist_items}.flatten : []
      set_data Mappers::QcDetailReportMapper.map checklist_items

      data = []
      @data.each do |entry|
        data += entry
      end

      return @headers + data
    end
  end
end
