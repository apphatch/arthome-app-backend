class Stock < ApplicationRecord
  has_and_belongs_to_many :shops
  has_many :checklist_items
  has_many :checklists, through: :checklist_items
  has_many :photos, as: :dbfile

  serialize :custom_attributes, Hash

  def category
    self.custom_attributes[:category] if self.custom_attributes.present?
  end

  def sub_category
    self.custom_attributes[:sub_category] if self.custom_attributes.present?
  end

  def sub_category= value
    nil
  end

  def category= value
    nil
  end
end
