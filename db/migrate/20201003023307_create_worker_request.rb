class CreateWorkerRequest < ActiveRecord::Migration[6.0]
  def change
    create_table :worker_requests do |t|
      t.string      :worker_class
      t.boolean     :deleted, default: false
      t.timestamps
    end
  end
end
