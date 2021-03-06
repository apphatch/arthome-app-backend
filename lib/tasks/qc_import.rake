desc "import scripts for qc"
namespace :qc_import do
  task :users, [:file] => [:environment] do |t, args|
    importer = Importers::QcUsersImporter.new file_name: args[:file], app: 'qc'
    importer.import
  end

  task :shops, [:file] => [:environment] do |t, args|
    importer = Importers::QcShopsImporter.new file_name: args[:file], app: 'qc'
    importer.import
  end

  task :stocks, [:file] => [:environment] do |t, args|
    importer = Importers::QcStocksImporter.new file_name: args[:file], app: 'qc'
    importer.import
  end

  task :checklists, [:file] => [:environment] do |t, args|
    importer = Importers::QcChecklistsImporter.new file_name: args[:file], app: 'qc'
    importer.import
  end

  task :checklist_items, [:file] => [:environment] do |t, args|
    importer = Importers::ChecklistItemsImporter.new file_name: args[:file], app: 'qc'
    importer.import
  end
end
