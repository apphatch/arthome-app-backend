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

      index :quantity, ['Stock'], as: :float
      index :mechanic, ['Mechanic']
      index :checklist_type, ['Type']
      index :yearweek, ['YearWeek'], as: :string
      index :date, ['Date'], as: :string
      index :photo_ref, ['Photo ID']
      associate :user, ['OSA Code'], as: :string
      associate :shop, ['Outlet', 'Outlet Name'], as: :string
      associate :stock, ['ULV code', 'Rental ID', 'Category'], as: :string

      super do |attributes, assocs, row|
        checklist_ref = [
          attributes[:checklist_type],
          attributes[:yearweek],
          attributes[:date],
          assocs[:user],
          assocs[:shop]
        ].join()

        assocs[:checklist] = Checklist.find_by_reference checklist_ref
        assocs[:stock] = Stock.find_by_importing_id assocs[:stock]
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
