class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_and_belongs_to_many :stocks
end
