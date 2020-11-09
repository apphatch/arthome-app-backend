class StockSerializer < ApplicationSerializer
  attributes :category, :name, :sku, :importing_id, :barcode, :rental_type
end
