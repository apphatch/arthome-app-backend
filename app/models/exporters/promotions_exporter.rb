module Exporters
  class PromotionsExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name', 'VN Descriptions',
        'Barcode', 'ULV code', 'Stock', 'Available', 'Void',
        'Promotion', 'OSA (Checker) Code', 'Mechanic', 'Note',
      ]

      mapper = Mappers::PromotionsExportMapper.new locale: @params[:locale]
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'promotion' &&
          date_filter(c.checklist, @params.slice(:date_from, :date_to)) &&
          yearweek_filter(c.checklist, @params.slice(:yearweek)) &&
          c.data[:error].nil?
      }).compact

      super
    end
  end
end
