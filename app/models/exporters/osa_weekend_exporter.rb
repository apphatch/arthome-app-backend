module Exporters
  class OsaWeekendExporter < BaseExporter
    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Outlet', 'Outlet Name', 'Barcode', 'VN Descriptions',
        'ULV code', 'Category', 'Result', 'Updated At', 'Error'
      ]

      criteria = {checklist_type: 'osa weekend'}
      if @params[:date_from]
        criteria = criteria.merge(date: @params[:date_from]..@params[:date_to])
      end
      criteria = criteria.merge(yearweek: @params[:yearweek]) if @params[:yearweek].present?

      mapper = Mappers::OsaWeekendExportMapper.new locale: @params[:locale]
      set_data mapper.map(
        ChecklistItem.active.includes(:checklist).where(
          checklists: criteria, exclude_from_search: false
        )
      ).compact

      super
    end
  end
end
