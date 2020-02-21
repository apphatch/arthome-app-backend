module Importers
  class ShopsImporter < BaseImporter
    def initialize params={}
      @model_class = Shop
      super params
    end

    def import
      index :importing_id, ['No.'], {is_uuid: true}
      index :name, ['Store Name']
      index :shop_type, ['Store Type (MT/DT/CVS)']
      index :full_address, ['Store Address']
      index :city, ['City']
      index :district, ['Quận']

      super
    end
  end
end
