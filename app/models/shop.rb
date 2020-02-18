class Shop < ApplicationRecord
  has_many :checklists
  has_many :users, through: :checklists
  has_and_belongs_to_many :stocks
end
