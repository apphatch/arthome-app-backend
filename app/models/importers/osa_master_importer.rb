module Importers
  class OsaMasterImporter
    def initialize params={}
      @params = params
      @app_group = 'osa'
      @file = params[:file]
    end

    def import
      importer = Importers::OsaShopsImporter.new file: @file, app_group: @app_group
      importer.import
      importer = Importers::OsaStocksImporter.new file: @file, app_group: @app_group
      importer.import
      importer = Importers::ChecklistsImporter.new file: @file, app_group: @app_group
      importer.import
      importer = Importers::ChecklistItemsImporter.new file: @file, app_group: @app_group
      importer.import
    end
  end
end
