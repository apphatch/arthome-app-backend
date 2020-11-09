class ApplicationSerializer < ActiveModel::Serializer
  def time
    #default for now
    super.in_time_zone 'Bangkok' if object.respond_to?(:time)
  end
end
