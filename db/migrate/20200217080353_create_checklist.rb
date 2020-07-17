class CreateChecklist < ActiveRecord::Migration[6.0]
  def change
    create_table :checklists do |t|
      t.references  :user
      t.references  :shop
      t.string      :reference
      t.string      :checklist_type
      t.boolean     :deleted, default: false
      t.boolean     :completed, default: false

      t.timestamps
    end
  end
end
