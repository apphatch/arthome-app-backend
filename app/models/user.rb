class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :shops
  has_many :checklists
end
