class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  validates :app_group, presence: true
  scope :active, -> { where(deleted: false) }
  scope :inactive, -> { where(deleted: true) }

  def self.current_time
    #default to VN time for now (only used here atm)
    return DateTime.now.in_time_zone 'Bangkok'
  end

  def deleted!
    self.deleted = true
    self.save validate: false
  end

  def self.project *attrs, take: nil
    if attrs.length == 1
      projection = self.all.collect{|record| record.send(attrs.first)}
    else
      projection = self.all.collect{|record| record.attributes.select{|k, v| k.to_sym.in?(attrs)}}
    end
    projection = projection.slice(0, take) if take.present?
    return projection
  end
end
