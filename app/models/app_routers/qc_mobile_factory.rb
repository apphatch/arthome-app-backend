module AppRouters
  class QcMobileFactory < BaseFactory
    def declare
      use 'qc-mobile', as: :app
      use 'qc', as: :app_group
      use Locality::BaseLocality.make('vn'), as: :default_locale
    end
  end
end
