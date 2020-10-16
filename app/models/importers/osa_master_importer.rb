module Importers
  class OsaMasterImporter
    def initialize params={}
      @params = params
      @app = 'osa'
      @file = params[:file]
    end

    def import
      importer = Importers::OsaShopsImporter.new file: @file, app: @app
      importer.import
      importer = Importers::OsaStocksImporter.new file: @file, app: @app
      importer.import
      importer = Importers::ChecklistsImporter.new file: @file, app: @app
      importer.import
      importer = Importers::ChecklistItemsImporter.new file: @file, app: @app
      importer.import
    end
  end
end
