module Importers
  class ChecklistItemsImporter < BaseSpreadsheetImporter
    def initialize params={}
      @model_class = ChecklistItem
      super params
    end

    def import
      is_uid :importing_id
      auto_gen_uid_with [
        :checklist_type,
        :yearweek, :date, :user,
        :shop, :stock
      ]

      index :quantity, ['Stock']
      index :mechanic, ['Mechanic']
      index :checklist_type, ['Type']
      index :yearweek, ['YearWeek']
      index :date, ['Date']
      index :photo_ref, ['Photo ID']
      associate :user, ['OSA Code']
      associate :shop, ['Outlet', 'Outlet Name']
      associate :stock, ['ULV code', 'Rental ID', 'Category']

      super do |attributes, assocs, row|
        checklist_ref = [
          attributes[:checklist_type],
          attributes[:yearweek],
          attributes[:date],
          assocs[:user],
          assocs[:shop]
        ].join()

        assocs[:checklist] = Checklist.find_by_reference checklist_ref
        assocs[:stock] = Stock.find_by_importing_id assocs[:stock].to_s
        assocs.delete :checklist_type #prevent no method error
        attributes.delete :date #prevent no method error, only used to construct checklist ref

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
