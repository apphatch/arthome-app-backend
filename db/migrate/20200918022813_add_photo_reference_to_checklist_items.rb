class AddPhotoReferenceToChecklistItems < ActiveRecord::Migration[6.0]
  def change
    add_column :checklist_items, :photo_ref, :string
  end
end
