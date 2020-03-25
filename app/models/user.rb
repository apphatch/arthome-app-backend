class User < ApplicationRecord
  has_many :checklists
  has_many :shops, through: :checklists
  has_many :photos, as: :dbfile
  has_many :checkin_checkouts

  has_secure_password
end
