desc "import scripts for osa"
namespace :osa_import do
  task :users, [:file] => [:environment] do |t, args|
    importer = Importers::OsaUsersImporter.new file_name: args[:file]
    importer.import
  end

  task :shops, [:file] => [:environment] do |t, args|
    importer = Importers::OsaShopsImporter.new file_name: args[:file]
    importer.import
  end

  task :stocks, [:file] => [:environment] do |t, args|
    importer = Importers::OsaStocksImporter.new file_name: args[:file]
    importer.import
  end

  task :checklists, [:file] => [:environment] do |t, args|
    importer = Importers::ChecklistsImporter.new file_name: args[:file]
    importer.import
  end

  task :checklist_items, [:file] => [:environment] do |t, args|
    importer = Importers::ChecklistItemsImporter.new file_name: args[:file]
    importer.import
  end
end
