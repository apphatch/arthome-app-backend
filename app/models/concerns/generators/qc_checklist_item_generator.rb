module Generators
  class QcChecklistItemGenerator < BaseGenerator
    def self.generate_hpc
      stock = Stock.active.where role: 'hpc'
      stock.each do |st|
        self.checklist_items.create stock: st
      end
    end

    def self.generate_ic
      stock = Stock.active.where role: 'ic'
      stock.each do |st|
        self.checklist_items.create stock: st
      end
    end

    def self.generate_hpcic
      stock = Stock.active.where role: ['hpc', 'ic']
      stock.each do |st|
        self.checklist_items.create stock: st
      end
    end
  end
end
