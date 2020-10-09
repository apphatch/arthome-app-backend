module AppRouters
  class QcMobileFactory < BaseFactory
    def declare
      use 'qc', as: :app
    end
  end
end
