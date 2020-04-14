class AddAttributesToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :barcode, :string
    add_column :stocks, :custom_attributes, :json
    add_column :stocks, :role, :string, default: 'stock'
  end
end
