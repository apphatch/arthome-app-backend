class CheckinCheckout < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :photos, as: :dbfile

  scope :user, -> { where.not(user: nil) }
  scope :shop, -> { where(user: nil) }
end
