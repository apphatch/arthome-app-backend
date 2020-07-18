class AddLockedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :locked, :boolean, default: false
  end
end
