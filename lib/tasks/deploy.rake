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
        match_tag_to: 'staging' # “match_tag_to” line to “staging”: This signifies that you will only push to production the code that has been pushed and tested on your staging. This insures that the staging step is never skipped.
      )

    deployment.deploy
  end
end