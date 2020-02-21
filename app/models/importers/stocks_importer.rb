module Importers
  class StocksImporter < BaseImporter
    def initialize params={}
      @klass = Stock
      super params
    end

    def import
      index :sku, ['SKU_Barcode'], {is_uuid: true}
      index :name, ['SKU_Name']
      super
    end
  end
end
