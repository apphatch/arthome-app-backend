module Locality
  class BaseLocality
    attr_accessor :definition

    def initialize params={}
      @definition = {
        code: 'VN',
        name: 'Vietnam',
        currency: 'VND',
        currency_factor: 1000,
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
  end
end
