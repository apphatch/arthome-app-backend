module Importers
  class ChecklistItemsImporter < BaseImporter
    def initialize params={}
      @model_class = ChecklistItem
      super params
    end

    def import
      index :importing_id, ['id'], {is_uuid: true}
      associate :checklist, ['checklist ref']
      associate :stock, ['ULV code', 'Sub Category']

      super do |attributes, assocs, row|
        assocs[:checklist] = Checklist.find_by_reference assocs[:checklist]
        assocs[:stock] = Stock.find_by_importing_id assocs[:stock]

        [attributes, assocs]
      end
    end
  end
end
