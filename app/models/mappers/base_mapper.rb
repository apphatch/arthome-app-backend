module Mappers
  class BaseMapper
    def initialize params={}
      @locale = params[:locale]
    end

    def apply_each object
      raise Exception.new 'supply map logic'
    end

    def map list
      return list.collect{|d| apply_each d}
    end
  end
end
