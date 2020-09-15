module Exporters
  class RentalExporter < BaseExporter
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
        c.checklist.yearweek == @params[:yearweek]
      }

      super
    end
  end
end
