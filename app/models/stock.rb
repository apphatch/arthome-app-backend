class Stock < ApplicationRecord
  has_and_belongs_to_many :shops
  has_many :checklist_items
  has_many :checklists, through: :checklist_items
  has_many :photos, as: :dbfile

  def category
    if self.custom_attributes.present?
      attrs = JSON.parse(self.custom_attributes).with_indifferent_access
      return attrs[:category]
    end
  end

  def category= value
    nil
  end
end
