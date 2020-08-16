require 'json'

class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_many :stocks, through: :checklist_items

  scope :active, -> { where(deleted: false) }
  scope :incompleted, -> { where(completed: false) }
  scope :today, -> { where(
    date: DateTime.now.beginning_of_day..DateTime.now.end_of_day
  )}

  def self.create params
    unless params[:checklist_type].present?
      raise Exception.new 'checklist must have a type'
    end

    super params
  end

  def template
    return JSON.parse(File.read("#{Rails.root.join(
      'app', 'models', 'checklist_item_templates', self.checklist_type)}.json")
    )
  end

  def update_checklist_items params
    data = JSON.parse(params['checklist_items'])

    data.each do |entry|
      item = self.checklist_items.find_by_id entry['id'].to_i
      item.update data: entry['data'].to_json if item.present?
    end

    self.completed!
  end

  def completed!
    self.update completed: true if self.checklist_items.collect{
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
