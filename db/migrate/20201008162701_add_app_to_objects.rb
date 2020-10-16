class AddAppToObjects < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :app_group, :string
    add_column :users, :app_group, :string
    add_column :shops, :app_group, :string
    add_column :stocks, :app_group, :string
    add_column :checkin_checkouts, :app_group, :string
    add_column :checklists, :app_group, :string
    add_column :checklist_items, :app_group, :string
  end
end
