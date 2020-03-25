class CheckinCheckout < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :photos, as: :dbfile
end
