require 'json'

class ChecklistItem < ApplicationRecord
  include Rails.application.routes.url_helpers
  include AttributeAliases::SosChecklistItem

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
end
