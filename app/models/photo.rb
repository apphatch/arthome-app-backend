class Photo < ApplicationRecord
  belongs_to :dbfile, polymorphic: true
  has_one_attached :image
end
