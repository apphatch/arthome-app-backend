module Exporters
  class SosExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name', 'Sub category',
        'Length of Unilever', 'Length of Competitor', 'OSA (Checker) Code'
      ]

      criteria = {checklist_type: 'sos'}
      if @params[:date_from]
        criteria = criteria.merge(date: @params[:date_from]..@params[:date_to])
      end
      criteria = criteria.merge(yearweek: @params[:yearweek]) if @params[:yearweek].present?

      mapper = Mappers::SosExportMapper.new locale: @params[:locale]
      set_data mapper.map(
        ChecklistItem.active.includes(:checklist).where(
          checklists: criteria, exclude_from_search: false
        )
      ).compact

      super
    end
  end
end
