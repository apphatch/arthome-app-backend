require 'json'

module Importers
  class StocksImporter < BaseImporter
    def initialize params={}
      @model_class = Stock
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['SKU_Barcode', 'ULV code', 'Sub Category']
      index :sku, ['SKU_Barcode', 'ULV code'], {allow_dup: true}
      index :name, ['SKU_Name', 'ULV DESCRIPTION', 'VI DESCRIPTION', 'ULV Description']
      index :barcode, ['barcode']
      index :role, ['role']
      associate :shops, ['Outlet']

      index :category, ['SKU_Categogy', 'Category']
      index :sub_category, ['Sub Category']
      index :division, ['Division']
      index :short_division, ['Short Division']
      index :group, ['SKU_Group']
      index :brand, ['Brand']
      index :role_shop, ['SKU_RoleShop']
      index :packaging, ['SKU_Package']

      super do |attributes, assocs, row|
        unless assocs[:shops].nil?
          assocs[:shops] = Shop.find_by_importing_id assocs[:shops]
        end
        attributes[:custom_attributes] = {
          category: attributes[:category],
          division: attributes[:division],
          short_division: attributes[:short_division],
          group: attributes[:group],
          brand: attributes[:brand],
          role_shop: attributes[:role_shop],
          packaging: attributes[:packaging]
        }.to_json
        [attributes, assocs]
      end
    end
  end
end
