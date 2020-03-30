class CreateChecklistItem < ActiveRecord::Migration[6.0]
  def change
    create_table :checklist_items do |t|
      t.references  :checklist
      t.references  :stock
      t.string      :importing_id
      t.json        :data
      t.boolean     :deleted, default: false

      t.timestamps
    end
  end
end
