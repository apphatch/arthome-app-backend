module Importers
  class QcShopsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Shop
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['No.']
      index :name, ['Store Name']
      index :shop_type, ['Shop_RoleShop']
      index :full_address, ['Store Address']
      index :city, ['City']
      index :district, ['Quận']
      index :distributor, ['NPP']
      index :shop_type_2, ['Store Type (MT/DT/CVS)']
      associate :users, ['US_ID']

      super do |attributes, assocs, row|
        assocs[:users] = User.find_by_importing_id assocs[:users].to_s

        attributes[:custom_attributes] = {
          distributor: attributes[:distributor],
          shop_type_2: attributes[:shop_type_2]
        }
        [attributes, assocs]
      end
    end
  end
end
