module Importers
  class OsaShopsImporter < BaseImporter
    def initialize params={}
      @model_class = Shop
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['Outlet']
      index :name, ['Outlet Name']
      index :shop_type, ['Outlet classification']
      index :full_address, ['Shop_Adress', 'Outlet Address']
      index :city, ['City', 'Province']
      index :district, ['District']
      associate :users, ['OSA Code']

      super do |attributes, assocs, row|
        assocs[:users] = User.find_by_importing_id assocs[:users].to_s

        [attributes, assocs]
      end
    end

    def self.template
      super [
        'Outlet', 'Outlet Name', 'Outlet classification',
        'Outlet Address', 'City', 'District', 'OSA Code'
      ]
    end
  end
end
