module Importers
  class BaseImporter
    def initialize params={}
      @klass = BaseSpreadsheetImporter
      @klass = BaseFileImporter if @model_class == Photo

      @klass_instance = @klass.new params
    end

    def import
      @klass_instance.import
    end

    def update
      @klass_instance.update
    end

    def self.template headers
      @klass.template headers
    end
  end
end
