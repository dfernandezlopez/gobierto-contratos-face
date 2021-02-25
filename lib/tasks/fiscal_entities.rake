# To call task rake bin/rake fiscal_entities:import_new_entities['<Level>']

namespace :fiscal_entities do
  desc "expand the number of entities, importing them from an official database called FACe"
  task :import_new_entities, [:level] => :environment do |_t, args|
    FiscalEntities.new(args.level).import_new_entities
  end
end
