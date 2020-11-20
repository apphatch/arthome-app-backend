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

    def self.make code='vn', params={}
      locality = self.localities[code.downcase.to_sym] || self.localities[:vn]
      return locality.new params
    end

    def adjust_for_timezone time
      raise Exception 'only accepts DateTime' unless time.instance_of?(DateTime)
      return time.in_time_zone(@definition[:timezone])
    end
  end
end
