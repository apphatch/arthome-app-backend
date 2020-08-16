class AddMechanicToChecklistItems < ActiveRecord::Migration[6.0]
  def change
    add_column :checklist_items, :mechanic, :string
  end
end
