desc "auto generator scripts"
namespace :autogen do
  task :qc_checklists, [:user_id] => [:environment] do |t, args|
    user = User.find_by_id args[:user_id]
    shops = user.shops
    generator = Generators::QcChecklistGenerator.new(
      user: user,
      shops: shops
    )
    generator.generate
  end
end
