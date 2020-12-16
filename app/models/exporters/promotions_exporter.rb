module Exporters
  class PromotionsExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name', 'VN Descriptions',
        'Barcode', 'ULV code', 'Stock', 'Available', 'Void',
        'Promotion', 'OSA (Checker) Code', 'Mechanic', 'Note',
      ]

      criteria = {checklist_type: 'promotion'}
      if @params[:date_from]
        criteria = criteria.merge(date: @params[:date_from]..@params[:date_to])
      end
      criteria = criteria.merge(yearweek: @params[:yearweek]) if @params[:yearweek].present?

      mapper = Mappers::PromotionsExportMapper.new locale: @params[:locale]
      set_data mapper.map(
        ChecklistItem.active.includes(:checklist).where(
          checklists: criteria, exclude_from_search: false
        )
      ).compact

      super
    end
  end
end
