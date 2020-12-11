module Reports
  class BaseReport
    include HashNormalizable

    def initialize params={}
      @params = normalize params
      @headers = []
      @data = []

      locale = @params[:locale]
      beginning_of_day = locale.try :adjust_for_timezone, DateTime.now.beginning_of_day
      end_of_day = locale.try :adjust_for_timezone, DateTime.now.end_of_day

      @params[:date_from] = @params[:date_from].present? ? DateTime.parse(@params[:date_from]) : beginning_of_day
      @params[:date_to] = @params[:date_to].present? ? DateTime.parse(@params[:date_to]) : end_of_day
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
