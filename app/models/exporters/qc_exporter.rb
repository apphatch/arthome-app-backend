module Exporters
  class QcExporter < BaseExporter
    include Filterable::ByDate

    def initialize params={}
      super params
    end

    def export
      @params[:date_from] = @params[:date_from].present? ? DateTime.parse(@params[:date_from]) : DateTime.now.beginning_of_day
      @params[:date_to] = @params[:date_to].present? ? DateTime.parse(@params[:date_to]) : DateTime.now.beginning_of_day

      set_headers [
        'Time', 'Store Type (MT/DT/CVS)', 'City', 'NPP', 'Tên Cửa Hàng',
        'Địa Chỉ', 'Audit', 'U/C', 'Package', 'Category', 'Product Group',
        'SKU Name', 'SKU', 'NSX or HSD', 'Số lô', 'Lỗi', 'Green', 'Yellow', 'Red', 'Image'
      ]

      mapper = Mappers::QcExportMapper.new locale: @locale
      set_data mapper.map ChecklistItem.active.where(app_group: 'qc').filter{ |c|
          c.data != {} &&
          updated_at_filter(c, @params)
      }
      set_flatten_level 2

      super
    end
  end
end
