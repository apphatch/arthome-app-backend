class ImportJob < ApplicationJob
  @queue = :import

  def self.perform id
    req = WorkerRequest.find_by_id id
    puts req
    puts 'not here' unless req.present?

    if req.present? && req.file.attached?
      file_path = ActiveStorage::Blob.service.url_for req.file.key
      importer = req.worker_klass.constantize.new file_path: file_path
      importer.import
    end
  end
end
