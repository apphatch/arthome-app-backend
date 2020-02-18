class CreateChecklistsAndStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :checklists_stocks, id: false do |t|
      t.belongs_to :checklist
      t.belongs_to :stock
    end
  end
end
