require 'json'

module Importers
  class OsaPhotosImporter < BaseFileImporter
    def initialize params={}
      @model_class = Photo
      @app_group = 'osa'
      @files = params[:files]

      super params
    end

    def import
      @files.each do |f|
        Photo.create(
          image: f,
          name: f.original_filename
        )
      end
    end
  end
end
