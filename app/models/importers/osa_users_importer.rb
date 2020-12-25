require 'json'

module Importers
  class OsaUsersImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = User
      @app_group = 'osa'
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['importing_id', 'OSA Code'], as: :string
      index :username, ['username', 'OSA Code'], as: :string
      index :password, ['password'], as: :string
      index :name, ['name', 'OSA Checker Name']
      index :role, ['role']

      super
    end

    def self.template file
      super [
        'importing_id', 'username', 'password',
        'name', 'role'
      ], file
    end
  end
end
