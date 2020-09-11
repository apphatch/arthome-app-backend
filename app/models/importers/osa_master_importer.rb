module Importers
  class OsaMasterImporter
    def initialize params={}
      @file = params[:file]
    end

    def import
      importer = Importers::OsaShopsImporter.new file: @file
      importer.import
      importer = Importers::OsaStocksImporter.new file: @file
      importer.import
      importer = Importers::ChecklistsImporter.new file: @file
      importer.import
      importer = Importers::ChecklistItemsImporter.new file: @file
      importer.import
    end
  end
end
