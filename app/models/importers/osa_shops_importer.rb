module Importers
  class OsaShopsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Shop
      @app_group = 'osa'
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['Outlet'], as: :string
      index :name, ['Outlet Name']
      index :shop_type, ['Outlet classification']
      index :full_address, ['Shop_Adress', 'Outlet Address']
      index :city, ['City', 'Province']
      index :district, ['District']
      associate :users, ['OSA Code'], as: :string

      super do |attributes, temp_attributes, assocs, row|
        #get rid of annoying floats
        attributes[:importing_id] = attributes[:importing_id].to_i.to_s
        assocs[:users] = User.active.find_by_importing_id assocs[:users]

        [attributes, temp_attributes, assocs]
      end
    end

    def self.template file
      super [
        'Outlet', 'Outlet Name', 'Outlet classification',
        'Outlet Address', 'City', 'District', 'OSA Code'
      ], file
    end
  end
end
