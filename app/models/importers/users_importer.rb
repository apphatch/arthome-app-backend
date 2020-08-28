require 'json'

module Importers
  class UsersImporter < BaseImporter
    def initialize params={}
      @model_class = User
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['importing_id', 'US_ID']
      index :username, ['username', 'US_Username']
      index :password, ['password']
      index :name, ['name', 'US_Name']
      index :role, ['role']

      super
    end
  end
end
