desc "auto generator scripts"
namespace :autogen do
  task :qc_checklist_items => [:environment] do |t, args|
    checklists = Checklist.active.this_week.qc
    generator = Generators::QcChecklistItemsGenerator.new checklists: checklists
    generator.generate
  end
end
