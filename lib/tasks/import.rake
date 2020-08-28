desc "import scripts"
namespace :import do
  task :users_osa, [:file] => [:environment] do |t, args|
    importer = Importers::UsersImporter.new file_name: args[:file]
    importer.import
  end

  task :users_qc, [:file] => [:environment] do |t, args|
    importer = Importers::UsersImporter.new file_name: args[:file]
    importer.import
  end

  task :shops_osa, [:file] => [:environment] do |t, args|
    importer = Importers::ShopsImporter.new file_name: args[:file]
    importer.import
  end

  task :shops_qc, [:file] => [:environment] do |t, args|
    importer = Importers::ShopsImporter.new file_name: args[:file]
    importer.import
  end

  task :stocks_osa, [:file] => [:environment] do |t, args|
    importer = Importers::StocksImporter.new file_name: args[:file]
    importer.import
  end

  task :stocks_qc, [:file] => [:environment] do |t, args|
    importer = Importers::StocksImporter.new file_name: args[:file]
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
