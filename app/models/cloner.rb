class Cloner
  def self.clone_checklists source_user, dest_user
    excluded_attributes_cl = ['id', 'user_id', 'updated_at', 'created_at']

    source_user.checklists.each do |cl|
      reference = "user_id_#{dest_user.id}-" + cl.reference + "-cloned"
      new_cl = dest_user.checklists.find_by_reference reference

      attributes = cl.attributes.filter{|k, v| excluded_attributes_cl.exclude? k}
      unless new_cl.present?
        new_cl = dest_user.checklists.new attributes
        new_cl.reference = reference
        new_cl.save!
      else
        new_cl.update attributes
      end
      self.clone_checklist_items cl, new_cl
    end
  end

  def self.clone_checklist_items source_checklist, dest_checklist
    excluded_attributes = ['id', 'updated_at', 'created_at']

    source_checklist.checklist_items.each do |cli|
      importing_id = "checklist_id_#{dest_checklist.id}" + cli.importing_id + "-cloned"
      new_cli = dest_checklist.checklist_items.find_by_importing_id importing_id

      attributes = cli.attributes.filter{|k, v| excluded_attributes.exclude? k}
      unless new_cli.present?
        new_cli = dest_checklist.checklist_items.new attributes
        new_cli.importing_id = importing_id
        new_cli.save!
      else
        new_cli.update attributes
      end
    end
  end

  def self.clone_shops source_user, dest_user
    source_user.shops.each do |s|
      unless dest_user.shops.include? s
        dest_user.shops.push s
      end
    end
    dest_user.save!
  end

  def self.clone_users source_shop, dest_shop
    source_shop.users.each do |u|
      unless dest_shop.users.include? u
        dest_shop.users.push u
      end
    end
    dest_shop.save!
  end
end
