require 'json'

class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_many :stocks, through: :checklist_items

  scope :incompleted, -> { where(completed: false) }
  scope :dated, -> { where.not(date: nil) }
  scope :undated, -> { where(date: nil) }
  scope :today, -> { where(
    date: DateTime.now.beginning_of_day..DateTime.now.end_of_day
  )}
  scope :this_week, -> { where(
    date: DateTime.now.beginning_of_week..DateTime.now.end_of_week
  )}
  scope :osa, -> { where(
    checklist_type: ['oos', 'sos', 'osa weekend', 'npd', 'rental', 'promotion']
  ) }
  scope :qc, -> { where(checklist_type: 'qc') }

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
    checklists = self.active.osa.incompleted if app == 'osa'
    checklists = self.active.qc.incompleted if app == 'qc'
    #not used for now, everything has a date
    #checklists = checklists.undated + checklists.dated.today
    checklists = checklist.dated.this_week
    return checklists.compact
  end

  def template
    return JSON.parse(File.read("#{Rails.root.join(
      'app', 'models', 'checklist_item_templates', self.checklist_type.downcase)}.json")
    )
  end

  def checklist_type
    super.downcase
  end

  #TODO: move or deprecate
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
  end

  def completed?
    self.completed
  end

  def empty?
    self.checklist_items.active.empty?
  end
end
