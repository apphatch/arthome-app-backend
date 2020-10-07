module Exporters
  class OosExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Category',
        'ULV Code', 'VN Descriptions', 'Barcode',
        'Stock', 'Available', 'Void', 'Note', 'Updated At', 'Error'
      ]
      set_data Mappers::OosExportMapper.map(ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'oos' &&
          date_filter(c, @params) && yearweek_filter(c, @params)
      }).compact

      super
    end
  end
end
