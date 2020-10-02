class CheckinCheckoutSerializer < ActiveModel::Serializer
  attributes :id, :time, :note, :is_checkin,
    :user_checkout, :shop_checkouts, :shop_checkout_photos,
    :created_at

  has_one :user
  #TODO fix this so it takes a proper serializer
  has_one :shop, serializer: nil

  has_many :photos, each_serializer: PhotoSerializer
  has_many :shop_checkout_photos, each_serializer: PhotoSerializer
  has_many :checkouts, each_serializer: CheckinCheckoutSerializer
  belongs_to :checkin, serializer: CheckinCheckoutSerializer

  #may need to refac
  def user_checkout
    cico = CheckinCheckout.new.attributes
    if object.user_checkout.present?
      photos = object.user_checkout.photos.collect do |p|
        PhotoSerializer.new(p).serializable_hash if p.present?
      end
      cico = object.user_checkout.serializable_hash.merge(photos: photos)
    end
  end

  def user_checkout_photos
    object.user_checkout.photos
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
