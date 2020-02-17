class CreateShop < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
