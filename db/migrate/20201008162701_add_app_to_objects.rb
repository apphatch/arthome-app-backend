class AddAppToObjects < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :app, :string
    add_column :users, :app, :string
    add_column :shops, :app, :string
    add_column :stocks, :app, :string
    add_column :checkin_checkouts, :app, :string
    add_column :checklists, :app, :string
    add_column :checklist_items, :app, :string
  end
end
