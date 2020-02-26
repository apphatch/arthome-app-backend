class ChecklistItem < ApplicationRecord
  belongs_to :checklist
  belongs_to :stock

  def code_name_mapping
  end
end
