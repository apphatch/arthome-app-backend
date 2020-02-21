module Importers
  class StocksImporter < BaseImporter
    def initialize params={}
      @klass = Stock
      super params
    end

    def import
      index :sku, ['SKU_Barcode'], {is_uuid: true}
      index :name, ['SKU_Name']
      index :barcode, ['barcode']
      index :role, ['SKU_Role']
      index :category, ['SKU_Categogy']
      index :group, ['SKU_Group']
      index :role_shop, ['SKU_RoleShop']
      index :packaging, ['SKU_Package']
      super
    end
  end
end
