module StatusCacheable
  extend ActiveSupport::Concern

  included do
    after_initialize :get_object_status_record
    before_save :save_object_status_record

    def get_object_status_record
      @status = self.object_status_record || ObjectStatusRecord.new(subject: self)
    end

    def save_object_status_record
      @status.save!
    end

    def update_object_status_record status_attributes
      get_object_status_record
      @status.data = @status.data.merge status_attributes
      save_object_status_record
    end
  end
end
