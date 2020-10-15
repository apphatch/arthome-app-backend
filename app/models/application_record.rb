class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  validates :app, presence: true
  scope :active, -> { where(deleted: false) }

  def deleted!
    self.deleted = true
    self.save validate: false
  end
end
