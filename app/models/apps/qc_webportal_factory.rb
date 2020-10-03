module Apps
  class QcWebportalFactory < BaseFactory
    def declare
      use Importers::QcUsersImporter, as: :user_importer
      use Importers::QcStocksImporter, as: :stock_importer
      use Importers::QcShopsImporter, as: :shop_importer
      use Importers::ChecklistsImporter, as: :checklist_importer
      use Importers::ChecklistItemsImporter, as: :checklist_item_importer

      use Reports::QcOverviewReport, as: :summary_report
    end
  end
end
