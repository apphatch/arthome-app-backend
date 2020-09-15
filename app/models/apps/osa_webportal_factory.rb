module Apps
  class OsaWebportalFactory < BaseFactory
    def declare
      use Importers::OsaUsersImporter, as: :user_importer
      use Importers::OsaStocksImporter, as: :stock_importer
      use Importers::OsaShopsImporter, as: :shop_importer
      use Importers::ChecklistsImporter, as: :checklist_importer
      use Importers::ChecklistItemsImporter, as: :checklist_item_importer
      use Importers::OsaMasterImporter, as: :master_importer

      use Exporters::OosExporter, as: :oos_exporter
    end
  end
end
