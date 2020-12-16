module Exporters
  class RentalExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name',
        'Rental ID', 'Sub category', 'Rental Type',
        'Available', 'Inline', 'Png', 'OSA (Checker) Code'
      ]

      criteria = {checklist_type: 'rental'}
      if @params[:date_from]
        criteria = criteria.merge(date: @params[:date_from]..@params[:date_to])
      end
      criteria = criteria.merge(yearweek: @params[:yearweek]) if @params[:yearweek].present?

      mapper = Mappers::RentalExportMapper.new locale: @params[:locale]
      set_data mapper.map(
        ChecklistItem.active.includes(:checklist).where(
          checklists: criteria, exclude_from_search: false
        )
      ).compact

      super
    end
  end
end
