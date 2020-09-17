class Photo < ApplicationRecord
  belongs_to :dbfile, polymorphic: true, optional: true
  has_one_attached :image
end
