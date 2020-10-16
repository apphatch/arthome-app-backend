module Importers
  class QcChecklistsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Checklist
      @app = 'qc'
      super params
    end

    def import
      is_uid :reference
      auto_gen_uid_with_attributes [:shop_number, :shop_name, :date], prefix: 'qc-'

      index_temp :shop_number, ['No.'], as: :string
      index_temp :shop_name, ['Store Name']
      index :date, ['Date'], as: :string
      associate :user, ['US_ID'], as: :string

      skip_if_record_exists

      super do |attributes, assocs, row|
        attributes[:checklist_type] = 'qc'
        attributes[:date] = DateTime.parse attributes[:date] if attributes[:date].present?

        assocs[:user] = User.find_by_importing_id assocs[:user]
        shop_id = "qc-" + attributes[:shop_number] + attributes[:shop_name]
        assocs[:shop] = Shop.find_by_importing_id shop_id


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
