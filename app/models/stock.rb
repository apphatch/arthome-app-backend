class Stock < ApplicationRecord
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :checklists
end
