class StockSerializer < ActiveModel::Serializer
  attributes :category, :name, :sku, :importing_id, :barcode, :rental_type
end
