module Exporters
  class OsaCheckinCheckoutExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'User ID', 'User Name',
        'Note', 'Date', 'Long', 'Lat', 'Checkin/checkout'
      ]

      mapper = Mappers::OsaCheckinCheckoutExportMapper.new locale: @params[:locale]
      set_data mapper.map(CheckinCheckout.active.user.filter{ |c|
        c.app_group == 'osa' &&
          created_at_filter(c, @params.slice(:date_from, :date_to))
      }).compact

      super
    end
  end
end
