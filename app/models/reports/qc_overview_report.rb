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

      criteria = {updated_at: @params[:date_from]..@params[:date_to]}
      unless @date_given
        criteria = criteria.merge(updated_at: Time.current.beginning_of_month..Time.current.end_of_month)
      end

      mapper = Mappers::QcOverviewReportMapper.new locale: @params[:locale]
      set_data mapper.map(
        Checklist.active.with_app_group('qc').includes(:checklist_items).where(
            exclude_from_search: false,
            checklist_items: criteria
        )
      ).compact

      super
    end
  end
end
