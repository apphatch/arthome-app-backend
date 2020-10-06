class Photo < ApplicationRecord
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
end
