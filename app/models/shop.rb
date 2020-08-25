require 'json'

class Shop < ApplicationRecord
  has_many :checklists
  has_and_belongs_to_many :users
  has_and_belongs_to_many :stocks
  has_many :checkin_checkouts

  has_many :photos, as: :dbfiles

  #TODO: refac to just be checkout (after top 2 methods moved)
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
        #TODO: fix how FE returns data to construct this object
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

  def completed? user
    checklists = self.checklists.where user: user
    checklists = checklists.undated + checklists.dated.today
    return checklists.collect{|c| c.completed?}.all?
  end
end
