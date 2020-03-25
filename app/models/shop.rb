class Shop < ApplicationRecord
  has_many :checklists
  has_many :users, through: :checklists
  has_and_belongs_to_many :stocks
  has_many :photos, as: :dbfile
  has_many :checkin_checkouts

  def checkin user, params
    return None unless [
      user.present?,
      params[:photo].present?,
      params[:time].present?
    ].all?

    begin
      record = user.checkin_checkouts.create(
        shop: self,
        time: params[:time],
      )
      record.photos.create data: params[:photo], time: params[:time]
      record.save
      return record
    except
      return None
    end
  end
end
