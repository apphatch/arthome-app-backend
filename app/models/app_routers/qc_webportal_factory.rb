module AppRouters
  class QcWebportalFactory < BaseFactory
    def declare
      use 'qc-webportal', as: :app
      use 'qc', as: :app_group

      use Importers::QcUsersImporter, as: :user_importer
      use Importers::QcStocksImporter, as: :stock_importer
      use Importers::QcShopsImporter, as: :shop_importer
      use Importers::QcChecklistsImporter, as: :checklist_importer

      use Exporters::QcExporter, as: :qc_exporter

      use Reports::QcOverviewReport, as: :summary_report
      use Reports::QcDetailReport, as: :detail_report
    end
  end
end
