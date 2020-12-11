module Exporters
  class OosExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name', 'Category',
        'VN Descriptions', 'Barcode', 'ULV Code',
        'Stock', 'Available', 'Void', 'OSA (Checker) Code', 'Note',
      ]

      mapper = Mappers::OosExportMapper.new locale: @params[:locale]
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'oos' &&
          date_filter(c.checklist, @params.slice(:date_from, :date_to)) &&
          yearweek_filter(c.checklist, @params.slice(:yearweek)) &&
          c.data[:error].nil?
      }).compact

      super
    end
  end
end
