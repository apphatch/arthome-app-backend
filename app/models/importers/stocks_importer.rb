module Importers
  class StocksImporter < BaseImporter
    def initialize params={}
      @model_class = Stock
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['ULV code', 'Rental ID', 'Category', 'SKU_Detail']
      index :sku, ['ULV code', 'Rental ID', 'SKU_SKU'], {allow_dup: true}
      index :name, ['VN Descriptions', 'Rental ID', 'Category', 'SKU_Name'], {allow_dup: true}
      index :barcode, ['barcode', 'Barcode', 'SKU_Barcode']
      index :role, ['role', 'SKU_RoleShop']
      associate :shops, ['Outlet', 'Shop_ID']

      index :category, ['Category', 'Rental Type', 'SKU_Categogy']
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
        attributes[:role] = attributes[:role].downcase
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
