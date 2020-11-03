class AddEndDateToChecklists < ActiveRecord::Migration[6.0]
  def change
    add_column :checklists, :end_date, :datetime
  end
end
