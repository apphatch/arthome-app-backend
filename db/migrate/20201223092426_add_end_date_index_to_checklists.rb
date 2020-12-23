class AddEndDateIndexToChecklists < ActiveRecord::Migration[6.0]
  def change
    add_index :checklists, :end_date
  end
end
