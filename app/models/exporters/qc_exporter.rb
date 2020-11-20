module Exporters
  class QcExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      set_headers [
        'Time', 'Store Type (MT/DT/CVS)', 'City', 'NPP', 'Tên Cửa Hàng',
        'Địa Chỉ', 'Audit', 'U/C', 'Package', 'Category', 'Product Group',
        'SKU Name', 'SKU', 'NSX or HSD', 'Lỗi', 'Green', 'Yellow', 'Red', 'Image'
      ]

      mapper = Mappers::QcExportMapper.new locale: @locale
      set_data mapper.map ChecklistItem.active.includes(:checklist).filter{ |c|
        c.checklist.checklist_type == 'qc' &&
          date_filter(c.checklist, @params)
      }
      set_flatten_level 2

      super
    end
  end
end
