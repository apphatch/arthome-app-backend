class CreateShopsAndUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :shops_users, id: false do |t|
      t.belongs_to :shop
      t.belongs_to :user
    end
  end
end
