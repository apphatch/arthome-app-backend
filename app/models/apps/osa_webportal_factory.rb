module Apps
  class OsaWebportalFactory < BaseFactory
    def declare
      use Importers::OsaUsersImporter, as: :user_importer
      use Importers::OsaStocksImporter, as: :stock_importer
      use Importers::OsaShopsImporter, as: :shop_importer
    end
  end
end
