class AddExcludeFromSearchToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :checkin_checkouts, :exclude_from_search, :boolean, default: false
    add_column :stocks, :exclude_from_search, :boolean, default: false
    add_column :users, :exclude_from_search, :boolean, default: false
    add_column :shops, :exclude_from_search, :boolean, default: false
    add_column :checklists, :exclude_from_search, :boolean, default: false
    add_column :checklist_items, :exclude_from_search, :boolean, default: false

    add_index :checkin_checkouts, :exclude_from_search
    add_index :stocks, :exclude_from_search
    add_index :users, :exclude_from_search
    add_index :shops, :exclude_from_search
    add_index :checklists, :exclude_from_search
    add_index :checklist_items, :exclude_from_search
  end
end

