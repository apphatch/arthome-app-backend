module Exporters
  class NpdExporter < BaseExporter
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
        c.checklist.yearweek == @params[:yearweek].to_s
      }

      super
    end
  end
end
