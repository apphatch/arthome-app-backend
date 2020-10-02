module Exporters
  class PromotionsExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Barcode', 'VN Descriptions',
        'ULV code', 'Sub category', 'Mechanic',
        'Stock', 'Available', 'Void', 'Promotion', 'Note'
      ]
      set_data Mappers::PromotionsExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'promotion' &&
          date_filter(c, @params) && yearweek_filter(c, @params)
      }

      super
    end
  end
end
