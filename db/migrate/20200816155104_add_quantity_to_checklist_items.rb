class AddQuantityToChecklistItems < ActiveRecord::Migration[6.0]
  def change
    add_column :checklist_items, :quantity, :float
  end
end
