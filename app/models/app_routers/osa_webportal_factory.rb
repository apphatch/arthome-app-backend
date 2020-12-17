module AppRouters
  class OsaWebportalFactory < BaseFactory
    def declare
      use 'osa-webportal', as: :app
      use 'osa', as: :app_group
      use Locality::BaseLocality.make('vn'), as: :default_locale

      use Importers::OsaUsersImporter, as: :user_importer
      use Importers::OsaStocksImporter, as: :stock_importer
      use Importers::OsaShopsImporter, as: :shop_importer
      use Importers::OsaChecklistsImporter, as: :checklist_importer
      use Importers::OsaChecklistItemsImporter, as: :checklist_item_importer
      use Importers::OsaPhotosImporter, as: :photo_importer
      use Importers::OsaMasterImporter, as: :master_importer

      use Exporters::OosExporter, as: :oos_exporter
      use Exporters::SosExporter, as: :sos_exporter
      use Exporters::NpdExporter, as: :npd_exporter
      use Exporters::PromotionsExporter, as: :promotion_exporter
      use Exporters::OsaWeekendExporter, as: :osa_weekend_exporter
      use Exporters::RentalExporter, as: :rental_exporter
      use Exporters::OsaCheckinCheckoutExporter, as: :checkin_checkout_exporter
      use Exporters::OsaPhotoExporter, as: :photo_exporter
    end
  end
end
