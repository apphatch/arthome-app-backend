require 'json'

module Importers
  class QcUsersImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = User
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['US_ID']
      index :username, ['US_Username']
      index :password, ['password']
      index :name, ['US_Name']
      index :role, ['role']

      super
    end

    def self.template
      super [
        'US_ID', 'US_Username', 'password',
        'US_Name', 'role'
      ]
    end
  end
end
