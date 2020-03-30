require 'json'

class ChecklistItem < ApplicationRecord
  belongs_to :checklist
  belongs_to :stock

  def template
    return JSON.parse(File.read("#{Rails.root.join(
      'app', 'models', 'checklist_item_templates', self.checklist_type)}.json")
    )
  end

  def checklist_type
    self.checklist.checklist_type
  end

  def data
    JSON.parse(super) unless super.nil?
  end
end
