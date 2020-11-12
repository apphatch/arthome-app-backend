module Exporters
  class SosExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day if @params[:date_from] == 'undefined'
      @params[:date_to] = DateTime.now.end_of_day if @params[:date_to] == 'undefined'

      set_headers [
        'Outlet', 'Outlet Name', 'Category', 'Sub category',
        'Length of Unilever', 'Length of Competitor', 'Updated At', 'Error'
      ]
      set_data Mappers::SosExportMapper.map(ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'sos' &&
          date_filter(c.checklist, @params) && yearweek_filter(c.checklist, @params)
      }).compact

      super
    end
  end
end
