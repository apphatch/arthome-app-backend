module Reports
  class BaseReport
    def initialize params={}
      @headers = []
      @data = []
    end

    def set_headers headers
      @headers = headers
    end

    def set_data data
      @data = data
    end

    def generate
      return @headers + @data
    end
  end
end
