module Reports
  class BaseReport
    def initialize params={}
      @headers = []
      @data = []
      @date_from = params[:date_from] != 'undefined' ? DateTime.parse(params[:date_from]) : DateTime.now.beginning_of_day
      @date_to = params[:date_to] != 'undefined' ? DateTime.parse(params[:date_to]) : DateTime.now.end_of_day
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

    def inspect
      return {
        headers: @headers,
        date_from: @date_from,
        date_to: @date_to
      }
    end
  end
end
