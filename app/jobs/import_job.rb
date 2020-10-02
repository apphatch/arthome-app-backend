class ImportJob < ApplicationJob
  @queue = :import

  def self.perform(importer)
    importer.import
  end
end