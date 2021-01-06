desc "data dump scripts"
namespace :dump do
  task :osa_photos_to_disk, [:end_time]=> [:environment] do |t, args|
    Time.zone = 'Bangkok'
    begin
      end_time = Time.current
      end_time = Time.zone.parse args[:end_time] if args[:end_time].present?
      start_time = end_time - 7.days
      Utils::OsaPhotoDumper.dump_to_disk Photo.active.where(
        app_group: 'osa',
        created_at: start_time..end_time
      )
    rescue => e
      puts e
    end
  end
end
