module Reports
  class QcDetailReport < BaseReport
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def generate
      set_headers [
        'Ngày', 'Nhân viên', 'Cửa hàng', 'Địa chỉ', 'SKU' ,'Mức cảnh báo', 'Lỗi', 'Hình ảnh'
      ]

      checklist_items = ChecklistItem.active.where(app_group: 'qc').collect{|c| c if (
          c.data != {} &&
          updated_at_filter(c, @params.slice(:date_to, :date_to))
        )
      }.compact

      mapper = Mappers::QcDetailReportMapper.new locale: @params[:locale]
      set_data mapper.map checklist_items

      data = []
      @data.each do |entry|
        data += entry
      end

      return [@headers] + data
    end
  end
end
