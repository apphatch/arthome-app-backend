class ChecklistSerializer < ActiveModel::Serializer
  attributes :id, :reference, :template

  has_many :checklist_items, each_serializer: ChecklistItemSerializer
end
