class AddIndicesToChecklists < ActiveRecord::Migration[6.0]
  def change
    add_index :checklists, :date
  end
end
