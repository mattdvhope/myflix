require 'paratrooper'

namespace :deploy do
  desc 'Deploy app in staging environment'
  task :staging do
    deployment = Paratrooper::Deploy.new("arcane-dusk-8223", tag: 'staging')

    deployment.deploy
  end

  desc 'Deploy app in production environment'
  task :production do
    deployment = Paratrooper::Deploy.new("aqueous-badlands-4150") do |deploy|
      deploy.tag              = 'production'
      deploy.match_tag        = 'staging' # “#match_tag” signifies that you will only push to production the code that has been pushed and tested on your staging. This insures that the staging step is never skipped.
      # deploy.maintenance_mode = !ENV['NO_MAINTENANCE']
    end

    deployment.deploy
  end
end