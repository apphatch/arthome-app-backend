class CheckinCheckoutSerializer < ActiveModel::Serializer
  attributes :id, :time, :note, :is_checkin,
    :user_checkout, :shop_checkouts, :shop_checkout_photos

  has_one :user
  has_one :shop
  has_many :photos, each_serializer: PhotoSerializer
  has_many :shop_checkout_photos, each_serializer: PhotoSerializer
  has_many :checkouts, each_serializer: CheckinCheckoutSerializer
  belongs_to :checkin, serializer: CheckinCheckoutSerializer

  def user_checkout
    object.user_checkout.present? ? object.user_checkout : CheckinCheckout.new.attributes
  end

  def shop_checkouts
    object.shop_checkouts.present? ? object.shop_checkouts : [CheckinCheckout.new.attributes]
  end

  def shop_checkout_photos
    if object.shop_checkouts.present?
      return object.shop_checkouts.collect{|c| c.photos}.flatten
    end
  end
end
