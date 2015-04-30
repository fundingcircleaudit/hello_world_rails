require "fc/deploy/deploy_probe"
require "capistrano/recipes/deploy/scm"

set :application, "hello_world_rails"
set :repository, "git@github.com:FundingCircle/hello_world_rails.git"
set :shipment_tracker, "http://shipment-tracker.herokuapp.com/deploys"

# Reconstructing interface usually setup by capistrano/recipes/deploy
set(:source) { Capistrano::Deploy::SCM.new(:git, self) }
set(:revision) { source.head }
set(:real_revision) { source.local.query_revision(revision) { |cmd| `#{cmd}` } }

task :deploy do
  system "git push --force heroku #{real_revision}:master"
end

# Deploy hook to record what got deployed
after "deploy" do
  Fc::Deploy::DeployProbe.for(application, shipment_tracker).send_event!
end
