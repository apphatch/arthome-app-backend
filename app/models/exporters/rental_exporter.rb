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
        'Available', 'Inline', 'Png'
      ]
      set_data Mappers::RentalExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'rental' &&
          date_filter(c, @params) && yearweek_filter(c, @params)
      }

      super
    end
  end
end
