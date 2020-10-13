require 'spreadsheet'

module Exporters
  class BaseExporter
    def initialize params={}
      @output_file = params[:output]
      @app = params[:app]
      @params = params
      @max_flatten_level = 1
    end

    def set_headers list
      @headers = list
    end

    def set_data list
      @data = list
    end

    def set_flatten_level level
      @max_flatten_level = level
    end

    def flatten_and_apply method, data, curr_level=0, curr_index=0
      if curr_level < @max_flatten_level
        data.each do |d|
          curr_index = flatten_and_apply method, d, curr_level + 1, curr_index
        end
      else
        method.call data, curr_index
      end
      return curr_index + 1
    end

    def export
      raise Exception.new 'provide headers as array' if @headers.empty?
      raise Exception.new 'provide data as array' unless @data.is_a?(Array)

      book = Spreadsheet::Workbook.new
      book.create_worksheet

      book.worksheet(0).insert_row(0, @headers)

      insert_into_spreadsheet = -> (row, index) {
        book.worksheet(0).insert_row(index+1, row)
      }
      flatten_and_apply insert_into_spreadsheet, @data

      book.write @output_file
    end
  end
end
