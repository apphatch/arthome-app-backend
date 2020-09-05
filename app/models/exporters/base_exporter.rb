require 'spreadsheet'

module Exporters
  class BaseExporter
    def initialize params={}
    end

    def set_headers list
      @headers = list
    end

    def set_data list
      @data = list
    end

    def export
      raise Exception.new 'provide headers as array' if @headers.empty?
      raise Exception.new 'provide data as array' if @data.empty?

      book = Spreadsheet::Workbook.new
      book.create_worksheet

      book.worksheet(0).insert_row(0, @headers)
      @data.each_with_index do |row, index|
        book.worksheet(0).insert_row(index+1, row)
      end

      #write to io stream for download
      data = StringIO.new("")
      book.write data
      return data
    end
  end
end
