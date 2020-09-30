require 'json'

class ChecklistItem < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :checklist
  belongs_to :stock

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

  def photo
    p = Photo.where(dbfile: nil).find_by_name self.photo_ref
    if p.present? && p.image.attached?
      return rails_blob_path(
        p.image,
        disposition: "preview",
        only_path: true
      )
    end
    return nil
  end

  def completed?
    return self.data.present?
  end

end
