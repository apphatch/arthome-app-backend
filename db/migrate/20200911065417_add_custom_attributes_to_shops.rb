class AddCustomAttributesToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :custom_attributes, :json
  end
end
