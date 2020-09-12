module Apps
  class QcMobileFactory < BaseFactory
    def declare
      use Importers::QcUsersImporter, as: :user_importer
      use Importers::QcStocksImporter, as: :stock_importer
      use Importers::QcShopsImporter, as: :shop_importer
      use Importers::ChecklistsImporter, as: :checklist_importer
      use Importers::ChecklistItemsImporter, as: :checklist_item_importer
    end
  end
end
