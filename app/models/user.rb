class User < ApplicationRecord
  has_many :checklists
  has_and_belongs_to_many :shops
  has_many :checkin_checkouts
  has_many :photos, as: :dbfiles

  has_secure_password

  def can_checkin?
    return true if self.checkin_checkouts.empty?
    return !self.last_checkin_checkout.is_checkin
  end

  def can_checkout? shop
    return false if self.checkin_checkouts.empty?
    #turn on later
    #return false unless self.checklists.collect{|c| c.completed?}.all?

    return false unless self.last_checkin_checkout.is_checkin
    return false unless shop.id == self.last_checkin_checkout.shop.id
    return true
  end

  def last_checkin_checkout
    return [] if self.checkin_checkouts.empty?
    return self.checkin_checkouts.order(:created_at).last
  end

  def active_shops
    incompleted_checklists = self.checklists.active.incompleted
    return incompleted_checklists.collect{|c| c.shop}.compact
  end
end
