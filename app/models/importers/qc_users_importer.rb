require 'json'

module Importers
  class QcUsersImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = User
      @app_group = 'qc'
      super params
    end

    def import
      is_uid :importing_id

      index :importing_id, ['US_ID'], as: :string
      index :username, ['US_Username'], as: :string
      index :password, ['password'], as: :string
      index :name, ['US_Name']
      index :role, ['role']

      super
    end

    def self.template file
      super [
        'US_ID', 'US_Username', 'password',
        'US_Name', 'role'
      ], file
    end
  end
end
