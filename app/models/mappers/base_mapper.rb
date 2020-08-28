module Mappers
  class BaseMapper
    def self.apply_each object
      raise Exception.new 'supply map logic'
    end

    def self.map list
      return list.collect{|d| self.apply_each d}
    end
  end
end
