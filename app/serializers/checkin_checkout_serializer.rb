class CheckinCheckoutSerializer < ActiveModel::Serializer
  attributes :id, :time, :note, :is_checkin, :user_checkout, :shop_checkouts

  has_one :user
  has_one :shop
  has_many :photos, each_serializer: PhotoSerializer
  has_many :checkouts, each_serializer: CheckinCheckoutSerializer
  belongs_to :checkin, serializer: CheckinCheckoutSerializer

  def user_checkout
    object.user_checkout.present? ? object.user_checkout : CheckinCheckout.new.attributes
  end

  def shop_checkouts
    object.shop_checkouts.present? ? object.shop_checkouts : [CheckinCheckout.new.attributes]
  end
end
