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
        checkin_checkout.note,
        checkin_checkout.created_at.strftime("%d/%m/%Y"),
        checkin_checkout.created_at.strftime("%H:%M"),
        checkin_checkout.coords,
        checkin_checkout.checkin? ? 'y' : 'n'
      ]
    end
  end
end
