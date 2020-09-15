module Exporters
  class OsaWeekendExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Barcode', 'VN Descriptions',
        'ULV code', 'Category', 'Result'
      ]
      set_data Mappers::OsaWeekendExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'osa weekend' &&
        c.checklist.yearweek == @params[:yearweek]
      }

      super
    end
  end
end
