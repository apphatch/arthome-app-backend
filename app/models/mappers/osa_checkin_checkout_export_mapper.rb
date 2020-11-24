module Mappers
  class OsaCheckinCheckoutExportMapper < BaseMapper
    def apply_each checkin_checkout
      shop = checkin_checkout.shop
      user = checkin_checkout.user
      return [
        shop.try(:importing_id),
        shop.try(:name),
        user.try(:importing_id),
        user.try(:name),
        (checkin_checkout.note unless checkin_checkout.note == 'undefined'),
        @locale.adjust_for_timezone(
          checkin_checkout.created_at
        ),
        checkin_checkout.coords[:longitude],
        checkin_checkout.coords[:latitude],
        checkin_checkout.checkin? ? 'checkin' : 'checkout'
      ]
    end
  end
end
