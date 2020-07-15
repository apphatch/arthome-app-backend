class StockSerializer < ActiveModel::Serializer
  attributes :category, :name, :sku, :importing_id, :barcode
end
