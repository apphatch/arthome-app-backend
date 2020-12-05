module Importers
  class OsaChecklistsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Checklist
      @app_group = 'osa'
      super params
    end

    def import
      is_uid :reference
      auto_gen_uid_with_attributes [:all]

      # order of indexing is important for checklist item import
      index_temp :shop, ['Outlet', 'Outlet Name'], as: :string
      index_temp :user, ['OSA Code'], as: :string
      index :checklist_type, ['Type']
      index :yearweek, ['YearWeek'], as: :string
      index :date, ['Date'], as: :string
      associate :user, ['OSA Code'], as: :string
      associate :shop, ['Outlet', 'Outlet Name'], as: :string

      skip_if_record_exists

      super do |attributes, temp_attributes, assocs, row|
        attributes[:checklist_type] = attributes[:checklist_type].downcase
        attributes[:date] = DateTime.parse attributes[:date] if attributes[:date].present?
        assocs[:user] = User.active.find_by_importing_id assocs[:user]
        assocs[:shop] = Shop.active.find_by_importing_id assocs[:shop].to_i.to_s

        [attributes, temp_attributes, assocs]
      end
    end

    def self.template file
      super [
        'Type', 'YearWeek', 'Date', 'OSA Code', 'Outlet',
        'ULV code', 'VN Descriptions', 'Category', 'Brand',
        'Barcode', 'Stock'
      ], file
    end
  end
end
