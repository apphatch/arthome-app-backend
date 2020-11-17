module HashNormalizable
  extend ActiveSupport::Concern

  included do
    def normalize hash
      hash.each do |k, v|
        hash[k] = nil if v.in?(['undefined', 'null'])
      end

      return hash
    end
  end
end
