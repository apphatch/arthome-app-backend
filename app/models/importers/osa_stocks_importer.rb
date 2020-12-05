module Importers
  class OsaStocksImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Stock
      @app_group = 'osa'
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['ULV code', 'Rental ID', 'Category'], as: :string
      index :sku, ['ULV code', 'Rental ID']
      index :name, ['VN Descriptions', 'Rental ID', 'Category'], as: :string
      index :barcode, ['barcode', 'Barcode']
      index :role, ['role']
      associate :shops, ['Outlet'], as: :string

      index :category, ['Category', 'Rental Type']
      index :sub_category, ['Sub Category']
      index :division, ['Division']
      index :short_division, ['Short Division']
      index :group, ['SKU_Group']
      index :brand, ['Brand']
      index :packaging, ['SKU_Package']
      index_temp :checklist_type, ['Type']

      super do |attributes, temp_attributes, assocs, row|
        if temp_attributes[:checklist_type].downcase == 'sos'
          attributes[:importing_id] = attributes[:category] + attributes[:sub_category]
        end

        unless assocs[:shops].nil?
          assocs[:shops] = Shop.active.find_by_importing_id assocs[:shops]
        end
        attributes[:role] = attributes[:role].try(:downcase)

        attributes[:custom_attributes] = {}
        [:category, :sub_category, :division, :short_division, :group, :brand, :packaging].each do |attr|
          attributes[:custom_attributes] = attributes[:custom_attributes].merge({attr => attributes[attr]})
          attributes.delete attr #so it doesn't get assigned to object by super
        end
        [attributes, temp_attributes, assocs]
      end
    end

    def self.template file
      super [
        'ULV Code', 'VN Descriptions', 'barcode', 'role', 'Outlet',
        'Category', 'Sub Category', 'Division'
      ], file
    end

    def self.template_rental file
      super [
        'Outlet', 'Outlet Name', 'Rental ID', 'Sub Category', 'Rental Type'
      ], file
    end
  end
end
