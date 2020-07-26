class AddYearweekToChecklists < ActiveRecord::Migration[6.0]
  def change
    add_column :checklists, :yearweek, :string
  end
end
