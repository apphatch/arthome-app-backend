class ChecklistSerializer < ActiveModel::Serializer
  attributes :id, :reference

  has_many :checklist_items
end
