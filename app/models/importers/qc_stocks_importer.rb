module Importers
  class QcStocksImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Stock
      @app_group = 'qc'
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['ID'], as: :string
      index :sku, ['SKU_SKU']
      index :name, ['SKU_Name'], as: :string
      index :barcode, ['SKU_Barcode']
      index :role, ['SKU_RoleShop']
      associate :shops, ['Shop_ID'], as: :string

      index :category, ['SKU_Categogy']
      index :group, ['SKU_Group']
      index :packaging, ['SKU_Package']
      index :uom, ['SKU_Role']
      index :uc, ['SKU_UC']

      super do |attributes, temp_attributes, assocs, row|
        unless assocs[:shops].nil?
          assocs[:shops] = Shop.active.find_by_importing_id assocs[:shops]
        end
        attributes[:role] = attributes[:role].try(:downcase)
        attributes[:custom_attributes] = {}
        [:category, :group, :packaging, :uom, :uc].each do |attr|
          attributes[:custom_attributes] = attributes[:custom_attributes].merge(
            attr => attributes[attr]
          )
          attributes.delete attr
        end
        [attributes, temp_attributes, assocs]
      end
    end
  end
end
