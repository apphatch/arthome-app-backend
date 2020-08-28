module Exporters
  class OosExporter < BaseExporter
    def self.export
      set_headers [
        'Outlet', 'Outlet Name', 'Category',
        'ULV Code', 'VN Descriptions', 'Barcode',
        'Stock', 'Available', 'Void', 'Note'
      ]
      set_data Mappers::OosExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.user.id == 1
      }
      super
    end
  end
end
