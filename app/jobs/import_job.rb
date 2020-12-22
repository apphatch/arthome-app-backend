class ImportJob
  @queue = :import

  def self.perform(id)
    req = WorkerRequest.find_by_id(id)
    puts req
    puts 'not here' and return if req&.file_path.blank?

    importer = req.worker_class.constantize.new(
      file: File.open(req.file_path, 'r'),
      app: req.app,
      app_group: req.app_group
    )

    importer.import
  end
end
