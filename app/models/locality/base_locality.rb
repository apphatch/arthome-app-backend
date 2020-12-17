module Locality
  class BaseLocality
    attr_accessor :definition

    def initialize params={}
      @definition = {
        code: 'VN',
        name: 'Vietnam',
        currency: 'VND',
        currency_factor: 1000,
        timezone: 'Bangkok'
      }
    end

    def self.localities
      return {
        vn: Locality::VnLocality
      }
    end

    def declare
      #do nothing, use default locale info
    end

    def use object, as: symbol
      @definition[symbol] = object
    end

    def get object_symbol
      return @definition[object_symbol]
    end

    def inspect
      return @definition
    end

    def self.make code=nil, params={}
      return nil if code.nil?
      locality = self.localities[code.downcase.to_sym]
      return locality.new params
    end

    def adjust_for_timezone time
      return time.to_datetime.in_time_zone(@definition[:timezone])
    end
  end
end
