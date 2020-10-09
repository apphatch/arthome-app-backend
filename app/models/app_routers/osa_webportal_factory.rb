module AppRouters
  class OsaWebportalFactory < BaseFactory
    def declare
      use 'osa', as: :app
      use Importers::OsaUsersImporter, as: :user_importer
      use Importers::OsaStocksImporter, as: :stock_importer
      use Importers::OsaShopsImporter, as: :shop_importer
      use Importers::ChecklistsImporter, as: :checklist_importer
      use Importers::ChecklistItemsImporter, as: :checklist_item_importer
      use Importers::OsaPhotosImporter, as: :photo_importer
      use Importers::OsaMasterImporter, as: :master_importer

      use Exporters::OosExporter, as: :oos_exporter
      use Exporters::SosExporter, as: :sos_exporter
      use Exporters::NpdExporter, as: :npd_exporter
      use Exporters::PromotionsExporter, as: :promotions_exporter
      use Exporters::OsaWeekendExporter, as: :osa_weekend_exporter
      use Exporters::RentalExporter, as: :rental_exporter
    end
  end
end
