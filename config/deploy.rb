require "fc/deploy/deploy_probe"
require "capistrano/recipes/deploy/scm"

# Standard FC deploy.rb settings
set :application, "hello_world_rails"
set :repository, "git@github.com:FundingCircle/hello_world_rails.git"
set :shipment_tracker, "http://shipment-tracker.herokuapp.com/deploys"
set :branch, ENV['TAG'] || "origin/#{ENV['BRANCH'] || 'production'}"

# Reconstructing interface usually setup by capistrano/recipes/deploy
set(:source) { Capistrano::Deploy::SCM.new(:git, self) }
set(:revision) { source.head }
set(:real_revision) { source.local.query_revision(revision) { |cmd| `#{cmd}` } }

task :deploy do
  puts "Deploying #{real_revision}"
  success = system "git push --force heroku #{real_revision}:master"
  raise "Deployment failed for #{real_revision}" unless success

  system "heroku config:set revision=#{real_revision}"
end

# Deploy hook to record what got deployed
after "deploy" do
  Fc::Deploy::DeployProbe.for(application, shipment_tracker).send_event!
end
