module Exporters
  class PromotionsExporter < BaseExporter
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
        c.checklist.yearweek == @params[:yearweek].to_s
      }

      super
    end
  end
end
