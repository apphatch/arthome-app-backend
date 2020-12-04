module Importers
  class QcChecklistsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = Checklist
      @app_group = 'qc'
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

      super do |attributes, temp_attributes, assocs, row|
        attributes[:checklist_type] = 'qc'
        if attributes[:date].present?
          begin
            date = DateTime.parse attributes[:date]
            attributes[:date] = date.beginning_of_month
            attributes[:end_date] = date.end_of_month
          rescue => e
            Rails.logger.warn "Something wrong with date parse"
            Rails.logger.warn e
          end
        end

        assocs[:user] = User.active.find_by_importing_id assocs[:user]
        shop_id = "qc-" + temp_attributes[:shop_number] + temp_attributes[:shop_name]
        assocs[:shop] = Shop.active.find_by_importing_id shop_id


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
