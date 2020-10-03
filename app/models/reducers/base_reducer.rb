module Reducers
  class BaseReducer
    def initialize params={}
    end

    def self.apply_each object
      raise Exception.new 'supply reduce logic for 1 object, returning a list of statistics'
    end

    def self.reduce list
      data = list.collect{|e| self.apply_each e}
      return data.transpose.map{|e| e.reduce(:+)}
    end
  end
end
