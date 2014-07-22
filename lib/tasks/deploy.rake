require 'paratrooper'

namespace :deploy do
  desc 'Deploy app in staging environment'
  task :staging do
    deployment = Paratrooper::Deploy.new("aqueous-badlands-4150-staging", tag: 'staging')

    deployment.deploy
  end

  desc 'Deploy app in production environment'
  task :production do
    deployment = Paratrooper::Deploy.new("aqueous-badlands-4150",
        tag: 'production',
        match_tag_to: 'staging'
      )

    deployment.deploy
  end
end