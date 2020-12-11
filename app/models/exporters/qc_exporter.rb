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
        'SKU Name', 'SKU', 'NSX or HSD', 'Số lô', 'Lỗi', 'Green', 'Yellow', 'Red', 'Image'
      ]

      mapper = Mappers::QcExportMapper.new locale: @params[:locale]
      set_data mapper.map ChecklistItem.active.where(app_group: 'qc').filter{ |c|
          c.data != {} &&
          updated_at_filter(c, @params.slice(:date_from, :date_to))
      }
      set_flatten_level 2

      super
    end
  end
end
