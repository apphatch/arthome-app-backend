module Importers
  class QcShopsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Shop
      @app_group = 'qc'
      super params
    end

    def import
      is_uid :importing_id
      auto_gen_uid_with_attributes [:shop_number, :name], prefix: 'qc-'

      index_temp :shop_number, ['No.'], as: :string
      index :name, ['Store Name']
      index :shop_type, ['Shop_RoleShop']
      index :full_address, ['Store Address']
      index :city, ['City']
      index :district, ['Quận']
      index :distributor, ['NPP']
      index :shop_type_2, ['Store Type (MT/DT/CVS)']
      associate :users, ['US_ID'], as: :string

      super do |attributes, temp_attributes, assocs, row|
        assocs[:users] = User.active.find_by_importing_id assocs[:users]

        attributes[:custom_attributes] = {
          distributor: attributes[:distributor],
          shop_type_2: attributes[:shop_type_2]
        }
        [attributes, temp_attributes, assocs]
      end
    end
  end
end
