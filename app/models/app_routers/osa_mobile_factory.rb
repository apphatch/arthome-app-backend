module AppRouters
  class OsaMobileFactory < BaseFactory
    def declare
      use 'osa', as: :app
    end
  end
end
