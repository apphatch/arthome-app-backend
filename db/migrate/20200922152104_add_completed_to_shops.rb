class AddCompletedToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :completed, :boolean, default: false
  end
end
