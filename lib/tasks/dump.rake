desc "data dump scripts"
namespace :dump do
  task :osa_photos_to_disk => [:environment] do |t, args|
    Utils::OsaPhotoDumper.dump_to_disk Photo.where(app_group: 'osa')
  end
end
