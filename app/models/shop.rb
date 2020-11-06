class Shop < ApplicationRecord
  include AttributeAliasable::QcShop
  include StatusCacheable

  has_one :object_status_record, as: :subject

  has_many :checklists
  has_many :checkin_checkouts
  has_and_belongs_to_many :users
  has_and_belongs_to_many :stocks

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
        checkin: last_record,
        coords: params[:coords],
        app_group: params[:app_group]
      )
      record.save validate: false

      params[:photos].each do |photo|
        record.photos.create(
          image: photo,
          time: params[:time],
          name: "shop_checkout_#{params[:time].to_s}",
          app_group: params[:app_group]
        )
      end
      return record
    rescue => e
      Rails.logger.warn e
      return record
      #return nil
    end
  end

  def shop_checkin_checkouts
    return self.checkin_checkouts.active.where user: nil
  end

  def completed? current_user
    #temporarily disable caching as it needs more thought
    #return @status.data[:incompleted_checklists_count] == 0 unless status.data[:incompleted_checklists_count].nil?

    if self.app_group == 'osa'
      checklists = self.checklists.active.incompleted.where(app_group: 'osa')
      daily = checklists.not_date_ranged.today.where(checklist_type: ['npd', 'promotion']).includes(:user)
      weekly = checklists.date_ranged.this_week.where.not(checklist_type: ['npd', 'promotion']).includes(:user)
      checklists = daily + weekly
    end
    checklists = self.checklists.active.incompleted.not_date_ranged.where(app_group: 'qc') if self.app_group == 'qc'

    #@status.data[:incompleted_checklists_count] = checklists.count{ |c|
    #  c.user == current_user && c.completed?
    #}
    checklists.each do |c|
      next if c.user != current_user
      return false unless c.completed?
    end
    return true
    #return @status.data[:incompleted_checklists_count] == 0
  end
end
