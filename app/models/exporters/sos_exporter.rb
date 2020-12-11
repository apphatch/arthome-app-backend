module Exporters
  class SosExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Updated At', 'Outlet', 'Outlet Name', 'Sub category',
        'Length of Unilever', 'Length of Competitor', 'OSA (Checker) Code'
      ]

      mapper = Mappers::SosExportMapper.new locale: @params[:locale]
      set_data mapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'sos' &&
          date_filter(c.checklist, @params.slice(:date_from, :date_to)) &&
          yearweek_filter(c.checklist, @params.slice(:yearweek)) &&
          c.data[:error].nil?
      }).compact

      super
    end
  end
end
