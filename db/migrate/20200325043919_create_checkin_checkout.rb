class CreateCheckinCheckout < ActiveRecord::Migration[6.0]
  def change
    create_table :checkin_checkouts do |t|
      t.references  :user, null: false, foreign_key: true
      t.references  :shop, null: false, foreign_key: true
      t.datetime    :time
      t.boolean     :deleted, default: false
      t.timestamps
    end
  end
end
