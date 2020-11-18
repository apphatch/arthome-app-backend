module Locality
  class BaseLocality
    attr_accessor :definition

    def initialize params={}
      @definition = {
        locale: 'VN',
        full_locale: 'Vietnam'
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
  end
end
