module Exporters
  class QcExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @headers = [
        'Time', 'Store Type (MT/DT/CVS)', 'NPP', 'Tên Cửa Hàng', 'Địa Chỉ', 'Audit',
        'U/C', 'Package', 'Category', 'Product Group', 'SKU Name', 'SKU', 'NSX or HSD',
        'Lỗi', 'Green', 'Yellow', 'Red', 'Image'
      ]
      @data = Mappers::QcExportMapper.map ChecklistItem.active.filter{ |c|
        c.checklist.checklist_type == 'qc' &&
          date_filter(c, @params)
      }

      book = Spreadsheet::Workbook.new
      book.create_worksheet

      book.worksheet(0).insert_row(0, @headers)
      rowcount = 0
      @data.each do |row|
        row.each do |subrow|
          rowcount += 1
          book.worksheet(0).insert_row(rowcount, subrow)
        end
      end

      book.write @output_file
    end
  end
end
