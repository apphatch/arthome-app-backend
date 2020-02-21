module Importers
  class ShopsImporter < BaseImporter
    def initialize params={}
      @klass = Shop
      super params
    end

    def import
      raise Exception.new 'pending shop file to implement'
    end
  end
end
