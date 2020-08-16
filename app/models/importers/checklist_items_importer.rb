module Importers
  class ChecklistItemsImporter < BaseImporter
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
      associate :user, ['OSA Code']
      associate :shop, ['Outlet']
      associate :stock, ['ULV code', 'Sub Category']

      super do |attributes, assocs, row|
        checklist_ref = [
          attributes[:checklist_type],
          attributes[:yearweek],
          attributes[:date],
          assocs[:user],
          assocs[:shop]
        ].join()

        attributes[:date] = nil
        assocs[:checklist] = Checklist.find_by_reference checklist_ref
        assocs[:stock] = Stock.find_by_importing_id assocs[:stock].to_s
        assocs.delete :checklist_type #prevent no method error

        [attributes, assocs]
      end
    end
  end
end
