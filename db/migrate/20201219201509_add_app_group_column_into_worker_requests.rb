class AddAppGroupColumnIntoWorkerRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :worker_requests, :app_group, :string
    add_column :worker_requests, :app, :string
    add_column :worker_requests, :file_path, :string
  end
end
