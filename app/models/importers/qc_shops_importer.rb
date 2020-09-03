module Importers
  class QcShopsImporter < BaseImporter
    def initialize params={}
      @model_class = Shop
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['Shop_ID']
      index :name, ['Shop_Name']
      index :shop_type, ['Shop_RoleShop']
      index :full_address, ['Shop_Adress', 'Outlet Address']
      index :city, ['City', 'Province']
      index :district, ['District']
      associate :users, ['US_ID']

      super do |attributes, assocs, row|
        assocs[:users] = User.find_by_importing_id assocs[:users].to_s

        [attributes, assocs]
      end
    end
  end
end
