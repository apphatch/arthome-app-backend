class CheckinCheckout < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shop
  has_many :photos, as: :dbfile

  has_many :checkouts, class_name: "CheckinCheckout",
    inverse_of: :checkin, foreign_key: "checkin_id"
  belongs_to :checkin, class_name: "CheckinCheckout",
    foreign_key: "checkin_id", optional: true

  serialize :coords, Hash

  scope :today, -> { where(
    created_at: Time.current.beginning_of_day..Time.current.end_of_day
  )}
  scope :month_to_date, -> { where(
    created_at: (Time.current.last_month)..Time.current
  )}
  scope :user, -> { where.not(user: nil) }
  scope :shop, -> { where(user: nil) }

  def longitude
    return self.coords[:longitude]
  end

  def latitude
    return self.coords[:latitude]
  end

  def checkin?
    return self.is_checkin
  end

  def checkout?
    return !self.is_checkin
  end

  def user_checkout
    return self.checkouts.find{|c| c.user.present?}
  end

  def shop_checkouts
    return self.checkouts.filter{|c| c.user.nil?}
  end
end
