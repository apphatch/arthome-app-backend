module Reports
  class QcDetailReport < BaseReport
    def generate
      set_headers [
        'Nhân viên', 'Cửa hàng', 'Địa chỉ', 'SKU' ,'Cảnh báo', 'Lỗi', 'Hình ảnh'
      ]

      set_data Mappers::QcDetailReportMapper.map Checklist.where(checklist_type: 'qc')

      data = []
      @data.each do |entry|
        data += entry
      end

      return @headers + data
    end
  end
end
