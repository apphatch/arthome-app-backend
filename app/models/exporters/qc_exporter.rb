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

      criteria = {}
      if @params[:date_from]
        criteria = criteria.merge(updated_at: @params[:date_from]..@params[:date_to])
      end

      mapper = Mappers::QcExportMapper.new locale: @params[:locale]
      set_data mapper.map(
        ChecklistItem.active.includes(:checklist).where(
          checklists: criteria, exclude_from_search: false
        ).where.not(data: {})
      ).compact
      set_flatten_level 2

      super
    end
  end
end
