module Importers
  class OsaChecklistItemsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = ChecklistItem
      @app_group = 'osa'
      super params
    end

    def import
      is_uid :importing_id
      auto_gen_uid_with_attributes [
        :checklist_type,
        :yearweek, :date, :user,
        :shop, :stock, :stock_sub_cat
      ]

      index :quantity, ['Stock'], as: :float
      index :mechanic, ['Mechanic']
      index :photo_ref, ['Photo ID']
      associate :stock, ['ULV code', 'Rental ID', 'Category'], as: :string

      index_temp :stock_sub_cat, ['Sub Category'], as: :string
      index_temp :checklist_type, ['Type']
      index_temp :yearweek, ['YearWeek'], as: :string
      index_temp :date, ['Date'], as: :string
      index_temp :shop, ['Outlet', 'Outlet Name'], as: :string
      index_temp :user, ['OSA Code'], as: :string

      super do |attributes, temp_attributes, assocs, row|
        date = DateTime.parse temp_attributes[:date] if temp_attributes[:date].present?

        checklist_ref = [
          temp_attributes[:shop].to_i.to_s,
          temp_attributes[:user],
          temp_attributes[:checklist_type].downcase,
          temp_attributes[:yearweek],
          date,
        ].join()

        assocs[:checklist] = Checklist.find_by_reference checklist_ref
        stock_importing_id = assocs[:stock]
        stock_importing_id += temp_attributes[:stock_sub_cat] if temp_attributes[:checklist_type].downcase == 'sos'
        assocs[:stock] = Stock.find_by_importing_id stock_importing_id
        #assocs.delete :checklist_type #prevent no method error

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
