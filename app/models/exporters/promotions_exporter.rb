module Exporters
  class PromotionsExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day if @params[:date_from] == 'undefined'
      @params[:date_to] = DateTime.now.end_of_day if @params[:date_to] == 'undefined'

      set_headers [
        'Outlet', 'Outlet Name', 'Barcode', 'VN Descriptions',
        'ULV code', 'Sub category', 'Mechanic',
        'Stock', 'Available', 'Void', 'Promotion', 'Note',
        'Updated At', 'Error'
      ]
      set_data Mappers::PromotionsExportMapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'promotion' &&
          date_filter(c.checklist, @params) && yearweek_filter(c.checklist, @params)
      }).compact

      super
    end
  end
end
