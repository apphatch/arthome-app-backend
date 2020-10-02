module Exporters
  class SosExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Category', 'Sub category',
        'Length of Unilever', 'Length of Competitor'
      ]
      set_data Mappers::SosExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'sos' &&
          date_filter(c, @params) && yearweek_filter(c, @params)
      }

      super
    end
  end
end
