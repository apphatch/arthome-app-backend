module Exporters
  class RentalExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Rental ID',
        'Rental Type', 'Sub category',
        'Available', 'Inline', 'Png', 'Updated At', 'Error'
      ]
      set_data Mappers::RentalExportMapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'rental' &&
          date_filter(c.checklist, @params) && yearweek_filter(c.checklist, @params)
      }).compact

      super
    end
  end
end
