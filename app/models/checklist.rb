require 'json'

class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_many :stocks, through: :checklist_items

  scope :incompleted, -> { where(completed: false) }

  scope :date_ranged, -> { where.not(date: nil).where.not(end_date: nil) }
  scope :not_date_ranged, -> { where.not(date: nil).where(end_date: nil) }
  scope :undated, -> { where(date: nil) }

  scope :today, -> { where(
    date: Time.current.beginning_of_day..Time.current.end_of_day
  )}
  scope :this_month, -> { where(
    date: Time.current.beginning_of_month..Time.current.end_of_month,
    end_date: Time.current.beginning_of_month..Time.current.end_of_month
  )}

  def self.create params
    unless params[:checklist_type].present?
      raise Exception.new 'checklist must have a type'
    else
      params[:checklist_type] = params[:checklist_type].downcase
    end

    super params
  end

  def self.index_for app
    raise Exception.new 'must provide app header' if app.nil?

    checklists = self.with_app_group('osa').not_date_ranged.today if app.name == 'osa-mobile'
    if app.name == 'qc-mobile'
      end_time = Time.current.beginning_of_month + 26.days
      start_time = end_time - 1.month + 1.day
      if Time.current.day > 26
        start_time += 1.month
        end_time += 1.month
      end
      checklists = self.with_app_group('qc').where(date: start_time..end_time).incompleted
    end
    return checklists
  end

  def template
    return JSON.parse(File.read("#{Rails.root.join(
      'app', 'models', 'checklist_item_templates', self.checklist_type.downcase)}.json")
    )
  end

  def checklist_type
    super.downcase
  end

  #TODO: remove, already in checklist_item model as bulk_update
  #check that checklist_item model is implemented correctly (JSON.parse?)
  def update_checklist_items params
    data = JSON.parse(params['checklist_items'])

    data.each do |entry|
      item = self.checklist_items.find_by_id entry['id'].to_i
      item.update data: entry['data'].to_json if item.present?
    end

    self.completed!
  end

  def completed!
    self.update completed: true if self.checklist_items.active.collect{
      |item| item.completed?
    }.all?

    #temporarily disable this
    #if self.completed?
    #  status = self.shop.try(:object_status_record)
    #  status.decrement_1 :incompleted_checklists_count if status.present?
    #end
  end

  def completed?
    self.completed
  end

  def empty?
    self.checklist_items.active.empty?
  end
end
