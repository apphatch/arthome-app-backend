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

      mapper = Mappers::OsaWeekendExportMapper.new locale: @params[:locale]
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'osa weekend' &&
          date_filter(c.checklist, @params.slice(:date_from, :date_to)) &&
          yearweek_filter(c.checklist, @params.slice(:yearweek))
      }).compact

      super
    end
  end
end
