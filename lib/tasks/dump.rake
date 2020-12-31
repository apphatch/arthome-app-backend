desc "data dump scripts"
namespace :dump do
  task :osa_photos_to_disk, [:start_time]=> [:environment] do |t, args|
    Time.zone = 'Bangkok'
    begin
      start_time = Time.zone.parse args[:start_time]
      Utils::OsaPhotoDumper.dump_to_disk Photo.active.where(
        app_group: 'osa',
        date: start_time..(start_time + 7.days)
      )
    rescue => e
      puts e
    end
  end
end
