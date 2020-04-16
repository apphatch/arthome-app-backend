class Shop < ApplicationRecord
  has_many :checklists
  has_and_belongs_to_many :users
  has_and_belongs_to_many :stocks
  has_many :checkin_checkouts

  has_many :photos, as: :dbfiles

  scope :active, -> {where(deleted: false, completed: false)}

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
      record.photos.create(
        image: params[:photo],
        time: params[:time],
        name: params[:photo_name]
      )
      record.save
      return record
    except
      return nil
    end
  end

  def check_is_completed!
    self.update completed: self.checklists.all{|c|
      c.completed?
    }.all?
  end

  def completed?
    return self.completed
  end
end
