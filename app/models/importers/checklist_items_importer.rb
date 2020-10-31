module Importers
  class ChecklistItemsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = ChecklistItem
      super params
    end

    def import
      is_uid :importing_id
      auto_gen_uid_with_attributes [
        :checklist_type,
        :yearweek, :date, :user,
        :shop, :stock
      ]

      index :quantity, ['Stock'], as: :float
      index :mechanic, ['Mechanic']
      index :checklist_type, ['Type']
      index :yearweek, ['YearWeek'], as: :string
      index :date, ['Date'], as: :string
      index :photo_ref, ['Photo ID']
      index :shop, ['Outlet', 'Outlet Name'], as: :string
      index :user, ['OSA Code'], as: :string
      associate :stock, ['ULV code', 'Rental ID', 'Category'], allow_dup: true, as: :string

      index_temp :checklist_type, ['Type']
      index_temp :stock_cat, ['Category'], allow_dup: true, as: :string
      index_temp :stock_sub_cat, ['Sub Category'], allow_dup: true, as: :string

      super do |attributes, assocs, row|
        date = DateTime.parse attributes[:date] if attributes[:date].present?

        checklist_ref = [
          attributes[:checklist_type].downcase,
          attributes[:yearweek],
          date,
          attributes[:user],
          attributes[:shop].to_i.to_s
        ].join()

        assocs[:checklist] = Checklist.find_by_reference checklist_ref
        if attributes[:checklist_type].downcase == 'sos'
          stock_importing_id = attributes[:stock_cat] + attributes[:stock_sub_cat]
        else
          stock_importing_id = assocs[:stock]
        end
        assocs[:stock] = Stock.find_by_importing_id stock_importing_id
        assocs.delete :checklist_type #prevent no method error

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
