module Utils
  class OsaPhotoDumper
    def initialize
    end

    def self.dump_to_disk photos
      puts 'dumping photos...'
      root = './photo_dump'
      raise Exception "#{root} doesn't exist" unless Dir.exist?(root)

      photos.find_each do |photo|
        checkin_checkout = photo.dbfile
        time_repr = checkin_checkout.created_at.strftime('%Y-%m-%d')
        shop_repr = [
          checkin_checkout.shop.try(:importing_id),
          photo.dbfile.shop.try(:name)
        ].join('-')

        #time/shop structure
        Dir.mkdir(File.join(root, time_repr), 000) unless Dir.exist?(File.join(root, time_repr))
        Dir.mkdir(File.join(root, time_repr, shop_repr), 000) unless Dir.exist?(File.join(root, time_repr, shop_repr))

        f = File.open File.join(root, time_repr, shop_repr), 'wb'
        f.write photo.image.download
        f.close()
      end
      puts 'done'
    end
  end
end
