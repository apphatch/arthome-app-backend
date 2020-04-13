class ChecklistSerializer < ActiveModel::Serializer
  attributes :id, :reference, :template, :checklist_type

  has_many :checklist_items, each_serializer: ChecklistItemSerializer

  def checklist_type
    super.upcase
  end
end
