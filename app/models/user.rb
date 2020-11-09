require 'roo'

class User < ApplicationRecord
  has_many :checklists
  has_and_belongs_to_many :shops
  has_many :checkin_checkouts
  has_many :photos, as: :dbfile

  has_secure_password

  scope :active, -> { where(deleted: false, locked: false) }

  def active_shops
    incompleted_checklists = self.checklists.active.incompleted
    return incompleted_checklists.collect{|c| c.shop}.compact.uniq
  end

  def checkin shop, params
    return nil unless [
      shop.present?,
      self.can_checkin?,
      params[:photo].present?,
      params[:time].present?
    ].all?

    begin
      record = self.checkin_checkouts.create(
        shop: shop,
        time: params[:time],
        note: params[:note],
        coords: params[:coords],
        is_checkin: true,
        app_group: params[:app_group]
      )

      record.photos.create(
        image: params[:photo],
        time: params[:time],
        name: params[:photo_name],
        app_group: params[:app_group]
      )
      record.save
      return record
    rescue
      return nil
    end
  end

  def checkout shop, params
    return nil unless [
      shop.present?,
      self.can_checkout?(shop),
      params[:photo].present?,
      params[:time].present?,
    ].all?

    begin
      last_record = self.last_checkin_checkout
      last_record = last_record.try(:checkin?) ? last_record : nil
      record = self.checkin_checkouts.create(
        shop: shop,
        time: params[:time],
        note: params[:note],
        coords: params[:coords],
        is_checkin: false,
        checkin: last_record,
        app_group: params[:app_group]
      )
      record.photos.create(
        image: params[:photo],
        time: params[:time],
        name: params[:photo_name],
        app_group: params[:app_group]
      )
      record.save
      #HACK: refac later as this pertains to osa project only
      if params[:incomplete] != 'false'
        checklists = self.checklists.active.where(
          shop: shop
        ).not_date_ranged.today.includes(:checklist_items)

        checklists.each do |c|
          c.checklist_items.each do |ci|
            ci.update data: {error: "cửa hàng đóng cửa"}
          end
          c.completed!
        end
      end
      return record
    rescue
      return nil
    end
  end

  def can_checkin?
    return true if self.checkin_checkouts.active.empty?
    return !self.last_checkin_checkout.is_checkin
  end

  def can_checkout? shop
    return false if self.checkin_checkouts.active.empty?
    #turn on later
    #return false unless self.checklists.collect{|c| c.completed?}.all?

    return false unless self.last_checkin_checkout.is_checkin
    return false unless shop.id == self.last_checkin_checkout.shop.id
    return true
  end

  def last_checkin_checkout
    return [] if self.checkin_checkouts.active.empty?
    return self.checkin_checkouts.active.order(:created_at).last
  end

  def admin?
    return self.role == 'admin'
  end

  def locked!
    self.update locked: true
  end

  def unlocked!
    self.update locked: false
  end

  def locked?
    return self.locked
  end

  def clear_checklists!
    self.checklists.each do |checklist|
      checklist.checklist_items.each do |item|
        next if item.data.nil?
        item.update data: nil
      end
      checklist.update completed: false
    end
  end

  def clear_checkin_checkouts!
    self.checkin_checkouts.each do |cico|
      cico.deleted!
    end
  end

  def self.mass_logout!
    User.all.each do |u|
      u.update jwt: nil
    end
  end
end
