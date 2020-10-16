module AppRouters
  class OsaMobileFactory < BaseFactory
    def declare
      use 'osa-mobile', as: :app
      use 'osa', as: :app_group
    end
  end
end
