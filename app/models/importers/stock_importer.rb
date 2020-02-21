module Importers
  class StockImporter < BaseImporter
    def initialize params={}
      @klass = Stock
      super params
    end

    def perform
      index :sku, ['SKU_Barcode'], {is_uuid: true}
      index :name, ['SKU_Name']
      import
    end
  end

end
