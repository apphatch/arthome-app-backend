module TimeZonable
  extend ActiveSupport::Concern

  def time
    #default for now
    object.time.try(:in_time_zone, 'Bangkok') if object.respond_to?(:time)
  end

  def created_at
    object.created_at.try(:in_time_zone, 'Bangkok') if object.respond_to?(:created_at)
  end
end
