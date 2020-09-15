module Exporters
  class OosExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Category',
        'ULV Code', 'VN Descriptions', 'Barcode',
        'Stock', 'Available', 'Void', 'Note'
      ]
      set_data Mappers::OosExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'oos' &&
        c.checklist.yearweek == @params[:yearweek]
      }

      super
    end
  end
end
