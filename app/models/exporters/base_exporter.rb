require 'spreadsheet'

module Exporters
  class BaseExporter
    def initialize params={}
      @output_file = params[:output]
      @params = params
    end

    def set_headers list
      @headers = list
    end

    def set_data list
      @data = list
    end

    def export
      raise Exception.new 'provide headers as array' if @headers.empty?
      raise Exception.new 'provide data as array' unless @data.is_a?(Array)

      book = Spreadsheet::Workbook.new
      book.create_worksheet

      book.worksheet(0).insert_row(0, @headers)
      @data.each_with_index do |row, index|
        book.worksheet(0).insert_row(index+1, row)
      end

      book.write @output_file
    end
  end
end
