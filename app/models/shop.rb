class Shop < ApplicationRecord
  has_many :checklists
  has_and_belongs_to_many :users
  has_and_belongs_to_many :stocks
  has_many :checkin_checkouts

  has_many :photos, as: :dbfiles

  scope :active, -> {where(deleted: false)}

  def checkin user, params
    return nil unless [
      user.present?,
      user.try(:can_checkin?),
      params[:photo].present?,
      params[:time].present?
    ].all?

    begin
      record = user.checkin_checkouts.create(
        shop: self,
        time: params[:time],
        note: params[:note],
        is_checkin: true
      )

      record.photos.create(
        image: params[:photo],
        time: params[:time],
        name: params[:photo_name],
      )
      record.save
      return record
    rescue
      return nil
    end
  end

  def checkout user, params
    return nil unless [
      user.present?,
      user.try(:can_checkout?, self),
      params[:photo].present?,
      params[:time].present?,
    ].all?

    begin
      record = user.checkin_checkouts.create(
        shop: self,
        time: params[:time],
        note: params[:note],
        is_checkin: false
      )
      record.photos.create(
        image: params[:photo],
        time: params[:time],
        name: params[:photo_name],
      )
      record.save
      return record
    rescue
      return nil
    end
  end

  def shop_checkout user, params
    begin
      record = self.checkin_checkouts.new(
        user: nil,
        time: params[:time],
        note: params[:note],
        is_checkin: false
      )
      record.save validate: false

      params[:photos].each do |photo|
        record.photos.create(
          image: photo,
          time: params[:time],
          name: "shop_checkout_#{params[:time].to_s}"
        )
      end
    rescue
      return nil
    end
  end

  def shop_checkin_checkouts
    return self.checkin_checkouts.where user: nil
  end

  def completed?
    return self.checklists.collect{|c| c.completed?}.all?
  end
end
