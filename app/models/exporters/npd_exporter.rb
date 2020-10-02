module Exporters
  class NpdExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Category',
        'ULV Code', 'VN Descriptions', 'Barcode',
        'Stock', 'Available', 'Void', 'Note'
      ]
      set_data Mappers::NpdExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'npd' &&
          date_filter(c, @params) && yearweek_filter(c, @params)
      }

      super
    end
  end
end
