class CreateObjectStatusRecord < ActiveRecord::Migration[6.0]
  def change
    create_table :object_status_records do |t|
      t.references  :subject, polymorphic: true, index: {name: :index_object_status_on_type_and_id}
      t.json        :data, default: {}
      t.boolean     :deleted, default: false

      t.timestamps
    end
  end
end
