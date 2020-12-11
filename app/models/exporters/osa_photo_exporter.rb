module Exporters
  class OsaPhotoExporter < BaseExporter
    #TODO: refine this
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      return Photo.where(app_group: 'osa').collect{|p| p.image_path}
    end
  end
end
