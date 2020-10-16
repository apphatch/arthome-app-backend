module AppRouters
  class QcMobileFactory < BaseFactory
    def declare
      use 'qc-mobile', as: :app
      use 'qc', as: :app_group
    end
  end
end
