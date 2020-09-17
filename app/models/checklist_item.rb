require 'json'

class ChecklistItem < ApplicationRecord
  belongs_to :checklist
  belongs_to :stock
  has_many :photos, as: :dbfiles

  serialize :data, Hash

  scope :incompleted, -> { where(data: nil) }

  def template
    return JSON.parse(File.read("#{Rails.root.join(
      'app', 'models', 'checklist_item_templates', self.checklist_type)}.json")
    )
  end

  def checklist_type
    self.checklist.try(:checklist_type)
  end

  def completed?
    return self.data.present?
  end
end
