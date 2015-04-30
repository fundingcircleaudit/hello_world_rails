require "fc/deploy/audit"
require "capistrano/recipes/deploy/scm"

server 'fc-hello-world-rails.herokuapp.com', :app

# Standard FC deploy.rb settings
set :application, 'hello_world_rails'
set :repository, 'git@github.com:FundingCircle/hello_world_rails.git'
set :shipment_tracker_url, 'http://shipment-tracker.herokuapp.com/deploys'
set :branch, ENV['TAG'] || "origin/#{ENV['BRANCH'] || 'master'}"

# Reconstructing interface usually setup by capistrano/recipes/deploy
set(:source) { Capistrano::Deploy::SCM.new(:git, self) }
set(:revision) { source.head }
set(:real_revision) { source.local.query_revision(revision) { |cmd| `#{cmd}` } }

task :deploy, roles: :app do
  puts "Deploying #{real_revision}"
  success = system "git push --force heroku #{real_revision}:master"
  raise "Deployment failed for #{real_revision}" unless success

  system "heroku config:set revision=#{real_revision}"
end

# Deploy hook to record what got deployed
after 'deploy' do
  servers = find_servers(roles: :app)
  servers.each do |server|
    Fc::Deploy::Audit.log_for(
        app_name: application,
        version: real_revision,
        server: server,
        endpoint_url: shipment_tracker_url
    )
  end
end
