require 'json'

module Importers
  class OsaUsersImporter < BaseSpreadsheetImporter
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

      skip_if_record_exists

      super
    end

    def self.template
      super [
        'importing_id', 'username', 'password',
        'name', 'role'
      ]
    end
  end
end
