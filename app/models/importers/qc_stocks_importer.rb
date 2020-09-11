module Importers
  class QcStocksImporter < BaseImporter
    def initialize params={}
      @model_class = Stock
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['SKU_Name']
      index :sku, ['SKU_SKU']
      index :name, ['SKU_Name'], {allow_dup: true}
      index :barcode, ['SKU_Barcode']
      index :role, ['SKU_RoleShop']
      associate :shops, ['Shop_ID']

      index :category, ['SKU_Category']
      index :sub_category, ['Sub Category']
      index :division, ['Division']
      index :short_division, ['Short Division']
      index :group, ['SKU_Group']
      index :brand, ['Brand']
      index :packaging, ['SKU_Package']

      super do |attributes, assocs, row|
        unless assocs[:shops].nil?
          assocs[:shops] = Shop.find_by_importing_id assocs[:shops]
        end
        attributes[:role] = attributes[:role].try(:downcase)
        attributes[:custom_attributes] = {
          category: attributes[:category],
          sub_category: attributes[:sub_category],
          division: attributes[:division],
          short_division: attributes[:short_division],
          group: attributes[:group],
          brand: attributes[:brand],
          packaging: attributes[:packaging]
        }
        [attributes, assocs]
      end
    end
  end
end
