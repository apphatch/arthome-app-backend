class AddExcludeFromSearchToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :checkin_checkouts, :exclude_from_search, :boolean, default: false
    add_column :stocks, :exclude_from_search, :boolean, default: false
    add_column :users, :exclude_from_search, :boolean, default: false
    add_column :shops, :exclude_from_search, :boolean, default: false
    add_column :checklists, :exclude_from_search, :boolean, default: false
    add_column :checklist_items, :exclude_from_search, :boolean, default: false
  end
end
