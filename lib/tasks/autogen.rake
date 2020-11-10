desc "auto generator scripts"
namespace :autogen do
  task :qc_checklist_items => [:environment] do |t, args|
    checklists = Checklist.active.date_ranged.this_week.where(app_group: 'qc')
    generator = Generators::QcChecklistItemsGenerator.new checklists: checklists
    generator.generate
  end
end
