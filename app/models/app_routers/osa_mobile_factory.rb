module AppRouters
  class OsaMobileFactory < BaseFactory
    def declare
      use 'osa-mobile', as: :app
      use 'osa', as: :app_group
      use Locality::BaseLocality.make('vn'), as: :default_locale
    end
  end
end
