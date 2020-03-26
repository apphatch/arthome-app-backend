module Importers
  class StocksImporter < BaseImporter
    def initialize params={}
      @model_class = Stock
      super params
    end

    def import
      index :sku, ['SKU_Barcode', 'ULV code'], {is_uuid: true}
      index :name, ['SKU_Name', 'ULV Description']
      index :barcode, ['barcode']
      index :role, ['SKU_Role']
      index :category, ['SKU_Categogy', 'Sub Category']
      index :group, ['SKU_Group', 'Category']
      index :role_shop, ['SKU_RoleShop']
      index :packaging, ['SKU_Package']
      associate :shops, ['Outlet']

      super do |attributes, assocs, row|
        unless assocs[:shops].nil?
          assocs[:shops] = Shop.find_by_importing_id assocs[:shops]
        end
        [attributes, assocs]
      end
    end
  end
end
