class Shop < ApplicationRecord
  has_many :checklists
  has_many :users, through: :checklists
  has_and_belongs_to_many :stocks
  has_many :photos, as: :dbfile
  has_many :checkin_checkouts

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
        data: params[:photo].read,
        time: params[:time],
        name: params[:photo_name]
      )
      record.save
      return record
    except
      return nil
    end
  end

  def checkout user, params
    return nil unless [
      user.present?,
      user.try(:can_checkout?, self),
      params[:photo].present?,
      params[:time].present?
    ].all?

    begin
      record = user.checkin_checkouts.create(
        shop: self,
        time: params[:time],
        note: params[:note],
        is_checkin: false
      )
      record.photos.create data: params[:photo], time: params[:time]
      record.save
      return record
    except
      return nil
    end
  end
end
