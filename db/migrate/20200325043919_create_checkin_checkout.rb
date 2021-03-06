class CreateCheckinCheckout < ActiveRecord::Migration[6.0]
  def change
    create_table :checkin_checkouts do |t|
      t.references  :user, foreign_key: true
      t.references  :shop, foreign_key: true
      t.datetime    :time
      t.text        :note
      t.boolean     :is_checkin, default: false
      t.boolean     :deleted, default: false
      t.timestamps
    end
  end
end
