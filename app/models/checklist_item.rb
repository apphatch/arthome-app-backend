require 'json'

class ChecklistItem < ApplicationRecord
  belongs_to :checklist
  belongs_to :stock

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

  def update_data params
    if self.checklist_type.try(:downcase) == 'qc'
      self.data = [] if self.data.empty?
      self.data.push params[:data]
      self.save!
    else
      self.update_attributes params
    end
  end
end
