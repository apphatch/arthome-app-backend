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
        c.checklist.user.importing_id == '19' &&
          c.checklist.checklist_type == 'oos' &&
          c.checklist.yearweek == '202036'
      }

      super
    end
  end
end
