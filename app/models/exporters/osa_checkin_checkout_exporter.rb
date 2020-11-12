module Exporters
  class OsaCheckinCheckoutExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_week if @params[:date_from].nil?
      @params[:date_to] = DateTime.now.end_of_week if @params[:date_to].nil?

      set_headers [
        'Outlet', 'Outlet Name', 'User ID', 'User Name',
        'Note', 'Date', 'Long', 'Lat', 'Checkin/checkout'
      ]
      set_data Mappers::OsaCheckinCheckoutExportMapper.map(CheckinCheckout.active.filter{ |c|
        c.app_group == 'osa' &&
          created_at_filter(c, @params)
      }).compact

      super
    end
  end
end
