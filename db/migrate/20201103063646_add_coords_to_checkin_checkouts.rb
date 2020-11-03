class AddCoordsToCheckinCheckouts < ActiveRecord::Migration[6.0]
  def change
    add_column :checkin_checkouts, :coords, :json
  end
end
