class Shop < ApplicationRecord
  include AttributeAliasable::QcShop

  has_many :checklists
  has_and_belongs_to_many :users
  has_and_belongs_to_many :stocks
  has_many :checkin_checkouts

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
    #HACK
    if current_app.name == 'osa'
      checklists = self.checklists.active.osa.incompleted
      #HACK
      #checklists = checklists.undated + checklists.dated.today
      checklists = checklists.dated
      daily = checklists.today.where checklist_type: ['npd', 'promotion']
      weekly = checklists.this_week.where.not checklist_type: ['npd', 'promotion']
      checklists = daily + weekly
    end
    checklists = self.checklists.active.qc.incompleted if current_app.name == 'qc'

    checklists.each do |c|
      next unless c.user == current_user
      return false unless c.completed?
    end
    return true
  end
end
