class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_and_belongs_to_many :stocks
end
