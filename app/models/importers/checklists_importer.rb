module Importers
  class ChecklistsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Checklist
      super params
    end

    def import
      is_uid :reference
      auto_gen_uid_with [:all]

      index :checklist_type, ['Type']
      index :yearweek, ['YearWeek'], as: :string
      index :date, ['Date'], as: :string
      associate :user, ['OSA Code'], as: :string
      associate :shop, ['Outlet', 'Outlet Name'], as: :string

      skip_if_record_exists

      super do |attributes, assocs, row|
        attributes[:checklist_type] = attributes[:checklist_type].downcase
        attributes[:date] = DateTime.parse attributes[:date] if attributes[:date].present?
        assocs[:user] = User.find_by_importing_id assocs[:user]
        assocs[:shop] = Shop.find_by_importing_id assocs[:shop].to_i.to_s

        [attributes, assocs]
      end
    end

    def self.template
      super [
        'Type', 'YearWeek', 'Date', 'OSA Code', 'Outlet',
        'ULV code', 'VN Descriptions', 'Category', 'Brand',
        'Barcode', 'Stock'
      ]
    end
  end
end
