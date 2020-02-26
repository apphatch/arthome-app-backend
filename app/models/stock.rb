class Stock < ApplicationRecord
  has_and_belongs_to_many :shops
  has_many :checklist_items
  has_many :checklists, through: :checklist_items
end
