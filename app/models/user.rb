class User < ApplicationRecord
  has_many :checklists
  has_many :shops, through: :checklists
  has_many :checkin_checkouts
  has_many :photos, as: :dbfiles

  has_secure_password

  def can_checkin?
    return true if self.checkin_checkouts.empty?
    return !self.checkin_checkouts.order(:created_at).last.is_checkin
  end

  def can_checkout? shop
    return false if self.checkin_checkouts.empty?

    last_checkin_checkout = self.checkin_checkouts.order(:created_at).last
    return false unless last_checkin_checkout.is_checkin
    return false unless shop.id == last_checkin_checkout.shop.id
    return true
  end
end
