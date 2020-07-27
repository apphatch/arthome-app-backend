require 'json'

module Importers
  class UsersImporter < BaseImporter
    def initialize params={}
      @model_class = User
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['importing_id']
      index :username, ['username']
      index :password, ['password']
      index :name, ['name']
      index :role, ['role']

      super
    end
  end
end
