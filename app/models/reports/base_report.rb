module Reports
  class BaseReport
    include HashNormalizable

    def initialize params={}
      @params = normalize params
      @headers = []
      @data = []

      @params[:date_from] = @params[:date_from].present? ? Time.parse(@params[:date_from]) : Time.current.beginning_of_day
      @params[:date_to] = @params[:date_to].present? ? Time.parse(@params[:date_to]) : Time.current.end_of_day
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
