module Generators
  class QcChecklistGenerator < BaseGenerator
    def initialize params={}
      @user = params[:user]
      @shops = params[:shops]
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
      t = DateTime.now
      @shops.each do |shop|
        checklist = shop.checklists.create(
          reference: "autogen-#{t.month}#{t.year}",
          user: @user,
          checklist_type: 'qc',
          yearweek: "#{t.year}#{t.month}"
        )
        generate_hpc(checklist) if shop.shop_type.downcase == 'hpc'
        generate_ic(checklist) if shop.shop_type.downcase == 'ic'
        generate_hpcic(checklist) if shop.shop_type.downcase == 'hpcic'
      end
    end

  end
end
