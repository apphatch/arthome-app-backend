class Cloner
  def self.clone_checklists source_user, dest_user
    excluded_attributes_cl = ['id', 'user_id', 'updated_at', 'created_at']

    source_user.checklists.each do |cl|
      new_cl = dest_user.checklists.new cl.attributes.filter{|k, v| excluded_attributes_cl.exclude? k}
      new_cl.reference = "user_id_#{dest_user.id}-" + new_cl.reference + "-cloned"
      new_cl.save!
      self.clone_checklist_items cl, new_cl
    end
  end

  def self.clone_checklist_items source_checklist, dest_checklist
    excluded_attributes = ['id', 'updated_at', 'created_at']

    source_checklist.checklist_items.each do |cli|
      new_cli = dest_checklist.checklist_items.new cli.attributes.filter{|k, v| excluded_attributes.exclude? k}
      new_cli.importing_id = "checklist_id_#{dest_checklist.id}" + new_cli.importing_id + "-cloned"
      new_cli.save!
    end
  end
end
