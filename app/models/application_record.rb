class ApplicationRecord < ActiveRecord::Base
  extend Projectable
  self.abstract_class = true

  validates :app_group, presence: true
  scope :with_app_group, -> (app_group) { where(app_group: app_group) }
  scope :active, -> { where(deleted: false) }
  scope :inactive, -> { where(deleted: true) }

  def deleted!
    self.deleted = true
    self.save validate: false
  end
end
