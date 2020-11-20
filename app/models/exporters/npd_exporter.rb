module Exporters
  class NpdExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day unless @params[:date_from]
      @params[:date_to] = DateTime.now.end_of_day unless @params[:date_to]

      set_headers [
        'Outlet', 'Outlet Name', 'Category',
        'ULV Code', 'VN Descriptions', 'Barcode',
        'Stock', 'Available', 'Void', 'Note', 'Updated At', 'Error'
      ]

      mapper = Mappers::NpdExportMapper.new locale: @locale
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'npd' &&
          date_filter(c.checklist, @params) && yearweek_filter(c.checklist, @params)
      }).compact

      super
    end
  end
end
