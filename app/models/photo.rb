class Photo < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :dbfile, polymorphic: true, optional: true
  has_one_attached :image

  def image_path
    if self.image.attached?
      return rails_blob_path(
        self.image,
        disposition: "preview",
        only_path: true
      )
    end
    return nil
  end

  def purge_image
    self.image.purge if self.image.attached?
  end
end
