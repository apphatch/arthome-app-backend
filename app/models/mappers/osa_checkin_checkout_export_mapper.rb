module Mappers
  class OsaCheckinCheckoutExportMapper < BaseMapper
    def self.apply_each checkin_checkout
      shop = checkin_checkout.shop
      user = checkin_checkout.user
      return [
        shop.try(:importing_id),
        shop.try(:name),
        user.try(:importing_id),
        user.try(:name),
        (checkin_checkout.note unless checkin_checkout.note == 'undefined'),
        checkin_checkout.created_at.in_time_zone('Bangkok'), #TODO: refac use locality
        checkin_checkout.coords[:longitude],
        checkin_checkout.coords[:latitude],
        checkin_checkout.checkin? ? 'checkin' : 'checkout'
      ]
    end
  end
end
