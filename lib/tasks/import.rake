desc "import scripts"
namespace :import do
  task :shops, [:file] => [:environment] do |t, args|
    importer = Importers::ShopsImporter.new file_name: args[:file]
    importer.import
  end

  task :stocks, [:file] => [:environment] do |t, args|
    importer = Importers::StocksImporter.new file_name: args[:file]
    importer.import
  end
end
