class CreateStock < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :importing_id
      t.string :sku
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
