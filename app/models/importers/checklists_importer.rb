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
      index :yearweek, ['YearWeek']
      index :date, ['Date']
      associate :user, ['OSA Code']
      associate :shop, ['Outlet', 'Outlet Name']

      skip_if_record_exists

      super do |attributes, assocs, row|
        attributes[:checklist_type] = attributes[:checklist_type].downcase
        attributes[:date] = DateTime.parse attributes[:date].to_s if attributes[:date].present?
        assocs[:user] = User.find_by_importing_id assocs[:user].to_s
        assocs[:shop] = Shop.find_by_importing_id assocs[:shop].to_s

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
