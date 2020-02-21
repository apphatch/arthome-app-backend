class ChecklistItem < ApplicationRecord
  belongs_to :checklist

  def code_name_mapping
  end
end
