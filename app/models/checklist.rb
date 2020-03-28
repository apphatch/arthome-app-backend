class Checklist < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_many :checklist_items
  has_many :stocks, through: :checklist_items

  def self.create params
    unless params[:checklist_type].present?
      raise Exception.new 'checklist must have a type'
    end

    super params
  end
end
