require 'json'

class ChecklistItem < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :checklist
  belongs_to :stock

  has_many :photos, as: :dbfile

  serialize :data, Hash

  scope :incompleted, -> { where(data: nil) }

  def self.bulk_update checklist_items
    checklist_items.each do |item|
      item = self.find_by_id item[:id]
      if item.present?
        item.update(item.except(:id))
      end
    end
  end

  def template
    return JSON.parse(File.read("#{Rails.root.join(
      'app', 'models', 'checklist_item_templates', self.checklist_type)}.json")
    )
  end

  def checklist_type
    self.checklist.try(:checklist_type)
  end

  def photo_with_path path
    return self.photos.find{|p| p.image_path == path}
  end

  def completed?
    return self.data.present?
  end
end
