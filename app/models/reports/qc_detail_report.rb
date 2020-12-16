module Reports
  class QcDetailReport < BaseReport
    def initialize params={}
      super params
    end

    def generate
      set_headers [
        'Ngày', 'Nhân viên', 'Cửa hàng', 'Địa chỉ', 'SKU' ,'Mức cảnh báo', 'Lỗi', 'Hình ảnh'
      ]

      criteria = {updated_at: @params[:date_from]..@params[:date_to]}

      mapper = Mappers::QcDetailReportMapper.new locale: @params[:locale]
      set_data mapper.map(
        ChecklistItem.active.includes(:checklist).with_app_group('qc').where(
          criteria.merge(exclude_from_search: false)
        ).where.not(data: {})
      ).compact

      data = []
      @data.each do |entry|
        data += entry
      end

      return [@headers] + data
    end
  end
end
