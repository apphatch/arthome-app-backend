class PhotoSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :time, :name, :image

  def image
    if object.image.attached?
      rails_blob_path(
        object.image,
        disposition: "preview",
        only_path: true
      )
    end
  end
end
