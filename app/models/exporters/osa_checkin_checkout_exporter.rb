module Exporters
  class OsaCheckinCheckoutExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day unless @params[:date_from].present?
      @params[:date_to] = DateTime.now.end_of_day unless @params[:date_to].present?

      set_headers [
        'Outlet', 'Outlet Name', 'User ID', 'User Name',
        'Note', 'Date', 'Long', 'Lat', 'Checkin/checkout'
      ]

      mapper = Mappers::OsaCheckinCheckoutExportMapper.new locale: @locale
      set_data mapper.map(CheckinCheckout.active.user.filter{ |c|
        c.app_group == 'osa' &&
          created_at_filter(c, @params)
      }).compact

      super
    end
  end
end
