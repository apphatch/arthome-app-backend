class Photo < ApplicationRecord
  belongs_to :dbfile, polymorphic: true
end
