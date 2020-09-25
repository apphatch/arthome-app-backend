class Shop < ApplicationRecord
  has_many :checklists
  has_and_belongs_to_many :users
  has_and_belongs_to_many :stocks
  has_many :checkin_checkouts

  has_many :photos, as: :dbfiles

  serialize :custom_attributes, Hash

  def checkout user, params
    begin
      last_record = user.last_checkin_checkout
      last_record = last_record.try(:checkin?) ? last_record : nil
      record = self.checkin_checkouts.new(
        user: nil,
        time: params[:time],
        note: params[:note],
        is_checkin: false,
        checkin: last_record
      )
      record.save validate: false

      params[:photos].each do |photo|
        record.photos.create(
          image: photo,
          time: params[:time],
          name: "shop_checkout_#{params[:time].to_s}"
        )
      end
      return record
    rescue
      return record
      #return nil
    end
  end

  def shop_checkin_checkouts
    return self.checkin_checkouts.active.where user: nil
  end

  def completed? current_app, current_user
    #TODO: need to create a table or something for this
    checklists = Checklist.index_for current_app.name

    checklists.each do |c|
      next unless c.user == current_user
      next unless c.shop == self
      return false unless c.completed?
    end
    return true
  end
end
