class CreateShopsAndStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :shops_stocks, id: false do |t|
      t.belongs_to :shop
      t.belongs_to :stock
    end
  end
end
