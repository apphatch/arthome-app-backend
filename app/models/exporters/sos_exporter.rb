module Exporters
  class SosExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Category',
        'Sub category', 'Stock',
        'Length of Unilever', 'Length of Competitor'
      ]
      set_data Mappers::SosExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'sos' &&
        c.checklist.yearweek == @params[:yearweek].to_s
      }

      super
    end
  end
end
