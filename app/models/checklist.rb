require 'json'

class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_many :stocks, through: :checklist_items

  scope :active, -> { where(deleted: false) }
  scope :incompleted, -> { where(completed: false) }

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
  end

  def completed?
    self.completed
  end

  def empty?
    self.checklist_items.active.empty?
  end
end
