module Importers
  class ChecklistsImporter < BaseImporter
    def initialize params={}
      @model_class = Checklist
      super params
    end

    def import
      is_uid :reference
      auto_gen_uid_with [:all]

      index :checklist_type, ['Type', 'type']
      index :yearweek, ['YearWeek']
      associate :user, ['OSA Code']
      associate :shop, ['Outlet']

      skip_if_record_exists

      super do |attributes, assocs, row|
        assocs[:user] = User.find_by_importing_id assocs[:user].to_s
        assocs[:shop] = Shop.find_by_importing_id assocs[:shop].to_s

        [attributes, assocs]
      end
    end
  end
end
