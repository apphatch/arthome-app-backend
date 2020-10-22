module Reports
  class BaseReport
    def initialize params={}
      @headers = []
      @data = []
      @date_from = DateTime.parse(params[:date_from] == 'undefined' ? '01-01-1900' : params[:date_from]) #almost guaranteed safe
      @date_to = DateTime.parse(params[:date_to]) if params[:date_to] != 'undefined'
    end

    def set_headers headers
      @headers = headers
    end

    def set_data data
      @data = data
    end

    def generate
      return [@headers] + @data
    end
  end
end
