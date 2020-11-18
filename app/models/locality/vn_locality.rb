module Locality
  class VnLocality < BaseLocality
    def declare
      use 'VN', as: :locale
      use 'Vietnam', as: :full_locale
      use 'VND', as: :currency
      use 1000, as: :currency_factor
    end
  end
end
