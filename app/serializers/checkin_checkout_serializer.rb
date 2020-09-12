class CheckinCheckoutSerializer < ActiveModel::Serializer
  attributes :id, :time, :note, :is_checkin, :user_checkout, :shop_checkouts,
    :shop_checkout_photos

  has_one :user
  has_one :shop
  has_many :photos, each_serializer: PhotoSerializer
  has_many :checkouts, each_serializer: CheckinCheckoutSerializer
  belongs_to :checkin, serializer: CheckinCheckoutSerializer

  def user_checkout
    object.user_checkout.present? ? object.user_checkout : CheckinCheckout.new.attributes
  end
end
