require 'json'

module Importers
  class OsaPhotosImporter < BaseImporter
    def initialize params={}
      @model_class = Photo
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['Photo ID']
      index :photo, ['photo']

      super
    end
  end
end
