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
        'Updated At', 'Outlet', 'Outlet Name', 'Category',
        'VN Descriptions', 'Barcode', 'ULV Code',
        'Stock', 'Available', 'Void', 'OSA (Checker) Code', 'Note'
      ]

      mapper = Mappers::NpdExportMapper.new locale: @locale
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'npd' &&
          date_filter(c.checklist, @params) &&
          yearweek_filter(c.checklist, @params) &&
          c.data[:error].nil?
      }).compact

      super
    end
  end
end
