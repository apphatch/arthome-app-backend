module Importers
  class StocksImporter < BaseImporter
    def initialize params={}
      @model_class = Stock
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['SKU_Barcode', 'ULV code', 'Sub Category', 'Rental ID']
      index :sku, ['SKU_Barcode', 'ULV code', 'Rental ID'], {allow_dup: true}
      index :name, ['SKU_Name', 'ULV DESCRIPTION', 'VI DESCRIPTION', 'ULV Description', 'VN Descriptions']
      index :barcode, ['barcode', 'Barcode']
      index :role, ['role']
      associate :shops, ['Outlet']

      index :category, ['SKU_Categogy', 'Category', 'Rental Type']
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
          sub_category: attributes[:sub_category],
          division: attributes[:division],
          short_division: attributes[:short_division],
          group: attributes[:group],
          brand: attributes[:brand],
          role_shop: attributes[:role_shop],
          packaging: attributes[:packaging]
        }
        [attributes, assocs]
      end
    end
  end
end
