class AddAttributesToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :shop_type, :string
    add_column :shops, :full_address, :string
    add_column :shops, :city, :string
    add_column :shops, :district, :string
  end
end
