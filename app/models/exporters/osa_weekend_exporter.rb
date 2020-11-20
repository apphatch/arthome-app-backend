module Exporters
  class OsaWeekendExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day unless @params[:date_from].present?
      @params[:date_to] = DateTime.now.end_of_day unless @params[:date_to].present?

      set_headers [
        'Outlet', 'Outlet Name', 'Barcode', 'VN Descriptions',
        'ULV code', 'Category', 'Result', 'Updated At', 'Error'
      ]

      mapper = Mappers::OsaWeekendExportMapper.new locale: @locale
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'osa weekend' &&
          date_filter(c.checklist, @params) && yearweek_filter(c.checklist, @params)
      }).compact

      super
    end
  end
end
