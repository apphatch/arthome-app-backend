class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_many :stocks, through: :checklist_items

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
end
