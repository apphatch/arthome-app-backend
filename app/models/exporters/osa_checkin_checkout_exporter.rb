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
      set_data Mappers::OsaCheckinCheckoutExportMapper.map(CheckinCheckout.active.filter{ |c|
        c.app_group == 'osa' &&
          date_filter(c, @params) && yearweek_filter(c, @params)
      }).compact

      super
    end
  end
end
