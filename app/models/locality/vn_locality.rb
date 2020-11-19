module Locality
  class VnLocality < BaseLocality
    def declare
      use 'VN', as: :code
      use 'Vietnam', as: :name
      use 'VND', as: :currency
      use 1000, as: :currency_factor
    end
  end
end
