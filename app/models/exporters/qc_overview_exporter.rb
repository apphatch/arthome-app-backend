module Exporters
  class QcOverviewExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Tên nhân viên', 'Tên cửa hàng', 'Địa chỉ', 'HPC', 'IC',
        'HPC thực', 'IC thực', 'Xanh', 'Vàng', 'Đỏ'
      ]

      criteria = {date: @params[:date_from]..@params[:date_to]}
      unless @date_given
        criteria = criteria.merge(date: Time.current.beginning_of_month..Time.current.end_of_month)
      end

      mapper = Mappers::QcOverviewReportMapper.new locale: @params[:locale]
      set_data mapper.map(
        Checklist.active.with_app_group('qc').where(
          criteria.merge(exclude_from_search: false)
        )
      ).compact

      super
    end
  end
end
