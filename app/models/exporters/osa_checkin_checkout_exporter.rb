module Exporters
  class OsaCheckinCheckoutExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'User ID', 'User Name',
        'Note', 'Date', 'Long', 'Lat', 'Checkin/checkout'
      ]

      criteria = {}
      if @params[:date_from]
        criteria = criteria.merge(created_at: @params[:date_from]..@params[:date_to])
      end

      mapper = Mappers::OsaCheckinCheckoutExportMapper.new locale: @params[:locale]
      set_data mapper.map(
        CheckinCheckout.active.user.with_app_group('osa').where(
          criteria.merge(exclude_from_search: false)
        )
      ).compact

      super
    end
  end
end
