module Exporters
  class OsaCheckinCheckoutExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day if @params[:date_from] == 'undefined'
      @params[:date_to] = DateTime.now.end_of_day if @params[:date_to] == 'undefined'

      set_headers [
        'Outlet', 'Outlet Name', 'User ID', 'User Name',
        'Note', 'Date', 'Long', 'Lat', 'Checkin/checkout'
      ]
      set_data Mappers::OsaCheckinCheckoutExportMapper.map(CheckinCheckout.active.user.filter{ |c|
        c.app_group == 'osa' &&
          created_at_filter(c, @params)
      }).compact

      super
    end
  end
end
