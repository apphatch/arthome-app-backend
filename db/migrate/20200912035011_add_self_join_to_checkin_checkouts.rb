class AddSelfJoinToCheckinCheckouts < ActiveRecord::Migration[6.0]
  def change
    add_column :checkin_checkouts, :checkin_id, :integer
  end
end
