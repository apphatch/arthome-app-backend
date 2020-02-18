class CreateStock < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :sku
      t.boolean :deleted

      t.timestamps
    end
  end
end
