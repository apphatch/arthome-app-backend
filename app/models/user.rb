class User < ApplicationRecord
  has_many :checklists
  has_many :shops, through: :checklists

  has_secure_password
end
