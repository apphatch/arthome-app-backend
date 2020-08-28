require 'spreadsheet'

module Exporters
  class BaseExporter
    def initialize params={}
    end

    def self.set_headers list
      @headers = list
    end

    def self.set_data list
      @data = list
    end

    def self.export
      raise Exception.new 'provide headers as array' if @headers.empty?
      raise Exception.new 'provide data as array' if @data.empty?

      @book = Spreadsheet::Workbook.new
      @book.create_worksheet

      @book.worksheet(0).insert_row(0, @headers)
      @data.each_with_index do |row, index|
        @book.worksheet(0).insert_row(index+1, row)
      end
      @book.write('test.xlsx')
      #write_data
      #@data = StringIO.new("")
      #@book.write data
    end
  end
end
