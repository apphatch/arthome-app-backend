class CheckinCheckoutSerializer < ActiveModel::Serializer
  attributes :id, :time, :note, :is_checkin, :user_checkout, :shop_checkouts

  has_one :user
  has_one :shop
  has_many :photos, each_serializer: PhotoSerializer
  has_many :checkout, each_serializer: CheckinCheckoutSerializer
  belongs_to :checkin, serializer: CheckinCheckoutSerializer
end
