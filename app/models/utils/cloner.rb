module Utils
  class Cloner
    def self.salt
      #prevents clash if same object is cloned multiple times
      return Random.hex
    end

    def self.clone_checklists_from source_user, to: dest_user
      raise Exception 'must provide destination user' if to.nil?
      dest_user = to
      excluded_attributes_cl = ['id', 'user_id', 'updated_at', 'created_at']

      source_user.checklists.each do |cl|
        reference = "cloned-checklistid-#{cl.id}-#{self.salt}"
        new_cl = dest_user.checklists.find_by_reference reference

        attributes = cl.attributes.filter{|k, v| excluded_attributes_cl.exclude? k}
        unless new_cl.present?
          new_cl = dest_user.checklists.new attributes
          new_cl.reference = reference
          new_cl.save!
        else
          new_cl.update! attributes
        end
        self.clone_checklist_items_from cl, to: new_cl
      end
    end

    def self.clone_checklist_items_from source_checklist, to: dest_checklist
      raise Exception 'must provide destination checklist' if to.nil?
      dest_checklist = to
      excluded_attributes = ['id', 'updated_at', 'created_at']

      source_checklist.checklist_items.each do |cli|
        importing_id = "cloned-checklistitemid-#{cli.id}-#{self.salt}"
        new_cli = dest_checklist.checklist_items.find_by_importing_id importing_id

        attributes = cli.attributes.filter{|k, v| excluded_attributes.exclude? k}
        unless new_cli.present?
          new_cli = dest_checklist.checklist_items.new attributes
          new_cli.importing_id = importing_id
          new_cli.save!
        else
          new_cli.update! attributes
        end
      end
    end

    def self.add_shops_from source_user, to: dest_user
      raise Exception 'must provide destination user' if to.nil?
      dest_user = to
      source_user.shops.each do |s|
        unless dest_user.shops.include? s
          dest_user.shops.push s
        end
      end
      dest_user.save!
    end

    def self.add_users_from source_shop, to: dest_shop
      raise Exception 'must provide destination shop' if to.nil?
      dest_shop = to
      source_shop.users.each do |u|
        unless dest_shop.users.include? u
          dest_shop.users.push u
        end
      end
      dest_shop.save!
    end
  end
end
