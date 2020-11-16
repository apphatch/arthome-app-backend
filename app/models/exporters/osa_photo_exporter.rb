module Exporters
  class OsaPhotoExporter < BaseExporter
    #TODO: refine this
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = DateTime.now.beginning_of_day unless @params[:date_from].present?
      @params[:date_to] = DateTime.now.end_of_day unless @params[:date_to].present?

      return Photo.where(app_group: 'osa').collect{|p| p.image_path}
    end
  end
end
