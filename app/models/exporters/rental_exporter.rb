module Exporters
  class RentalExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day unless @params[:date_from].present?
      @params[:date_to] = DateTime.now.end_of_day unless @params[:date_to].present?

      set_headers [
        'Updated At', 'Outlet', 'Outlet Name',
        'Rental ID', 'Sub category', 'Rental Type',
        'Available', 'Inline', 'Png', 'OSA (Checker) Code'
      ]

      mapper = Mappers::RentalExportMapper.new locale: @locale
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'rental' &&
          date_filter(c.checklist, @params) &&
          yearweek_filter(c.checklist, @params) &&
          c.data[:error].nil?
      }).compact

      super
    end
  end
end
