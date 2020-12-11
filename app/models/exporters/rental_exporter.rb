module Exporters
  class RentalExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name',
        'Rental ID', 'Sub category', 'Rental Type',
        'Available', 'Inline', 'Png', 'OSA (Checker) Code'
      ]

      mapper = Mappers::RentalExportMapper.new locale: @params[:locale]
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'rental' &&
          date_filter(c.checklist, @params.slice(:date_from, :date_to)) &&
          yearweek_filter(c.checklist, @params.slice(:yearweek)) &&
          c.data[:error].nil?
      }).compact

      super
    end
  end
end
