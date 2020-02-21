class CreateChecklistItem < ActiveRecord::Migration[6.0]
  def change
    create_table :checklist_items do |t|
      t.references  :checklist
      t.string      :code
      t.string      :name
      t.string      :status
      t.text        :note
      t.boolean     :deleted, default: false

      t.timestamps
    end
  end
end
