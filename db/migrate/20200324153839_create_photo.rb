class CreatePhoto < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string      :name
      t.binary      :data
      t.datetime    :time
      t.references  :dbfile, polymorphic: true
      t.boolean     :deleted, default: false
      t.timestamps
    end
  end
end
