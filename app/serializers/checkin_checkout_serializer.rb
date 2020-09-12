class CheckinCheckoutSerializer < ActiveModel::Serializer
  attributes :id, :time, :note, :is_checkin

  has_one :user
  has_one :shop
  has_many :photos, each_serializer: PhotoSerializer
  has_one :checkout, serializer: CheckinCheckoutSerializer
  belongs_to :checkin, serializer: CheckinCheckoutSerializer
end
