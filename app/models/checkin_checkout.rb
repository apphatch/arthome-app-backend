class CheckinCheckout < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :photos, as: :dbfile

  belongs_to :checkin, class_name: "CheckinCheckout",
    foreign_key: "checkin_id", optional: true

  scope :user, -> { where.not(user: nil) }
  scope :shop, -> { where(user: nil) }
end
