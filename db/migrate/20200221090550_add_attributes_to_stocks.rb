class AddAttributesToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :barcode, :string
    add_column :stocks, :category, :string
    add_column :stocks, :group, :string
    add_column :stocks, :role, :string
    add_column :stocks, :packaging, :string
    add_column :stocks, :role_shop, :string
  end
end
