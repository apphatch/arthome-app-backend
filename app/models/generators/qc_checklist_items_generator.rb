module Generators
  class QcChecklistItemsGenerator < BaseGenerator
    def initialize params={}
      @checklists = params[:checklists]
      super params
    end

    def generate_hpc checklist
      stock = Stock.active.where role: 'hpc'
      stock.each do |st|
        checklist.checklist_items.create stock: st
      end
    end

    def generate_ic checklist
      stock = Stock.active.where role: 'ic'
      stock.each do |st|
        checklist.checklist_items.create stock: st
      end
    end

    def generate_hpcic checklist
      stock = Stock.active.where role: ['hpc', 'ic']
      stock.each do |st|
        checklist.checklist_items.create stock: st
      end
    end

    def generate
      @checklists.each do |checklist|
        next if checklist.checklist_items.present?
        generate_hpc(checklist) if checklist.shop.shop_type.downcase == 'hpc'
        generate_ic(checklist) if checklist.shop.shop_type.downcase == 'ic'
        generate_hpcic(checklist) if checklist.shop.shop_type.downcase == 'hpcic'
      end
    end

  end
end
