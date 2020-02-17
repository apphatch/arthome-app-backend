class CreateChecklist < ActiveRecord::Migration[6.0]
  def change
    create_table :checklists do |t|
      t.string :reference
      t.boolean :deleted

      t.timestamps
    end
  end
end
