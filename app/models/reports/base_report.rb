module Reports
  class BaseReport
    def initialize params={}
      @headers = []
      @data = []
      @date_from = DateTime.parse(params[:date_from] || '01-01-1900') #almost guaranteed safe
      @date_to = DateTime.parse(params[:date_to]) if params[:date_to].present?
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
