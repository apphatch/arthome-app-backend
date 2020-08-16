class AddDateToChecklists < ActiveRecord::Migration[6.0]
  def change
    add_column :checklists, :date, :datetime
  end
end
