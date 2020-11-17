class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  validates :app_group, presence: true
  scope :active, -> { where(deleted: false) }

  def self.current_time
    #default to VN time for now (only used here atm)
    return DateTime.now.in_time_zone 'Bangkok'
  end

  def deleted!
    self.deleted = true
    self.save validate: false
  end
end
