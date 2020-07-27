module Importers
  class ShopsImporter < BaseImporter
    def initialize params={}
      @model_class = Shop
      super params
    end

    def import
      index :importing_id, ['No.', 'Outlet']
      index :name, ['Store Name', 'Outlet Name']
      index :shop_type, ['Store Type (MT/DT/CVS)', 'Outlet classification']
      index :full_address, ['Store Address', 'Outlet Address']
      index :city, ['City', 'Province']
      index :district, ['Quận', 'Distrist']
      associate :users, ['OSA Code']

      super do |attributes, assocs, row|
        attributes[:importing_id] = auto_generate_uuid attributes
        assocs[:users] = User.find_by_importing_id assocs[:users].to_s

        [attributes, assocs]
      end
    end
  end
end
