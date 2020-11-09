module Exporters
  class OsaWeekendExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Barcode', 'VN Descriptions',
        'ULV code', 'Category', 'Result', 'Updated At', 'Error'
      ]

      set_data Mappers::OsaWeekendExportMapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'osa weekend' &&
          date_filter(c.checklist, @params) && yearweek_filter(c.checklist, @params)
      }).compact

      super
    end
  end
end
