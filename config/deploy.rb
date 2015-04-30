set :application, "hello_world_rails"

require "fc-deploy"

before "deploy" do
end

after "deploy" do
  # Fc::Deploy::DeployProbe.for(application, "http://localhost:3000/deploys").send_event!
  Fc::Deploy::DeployProbe.for(application, "http://shipment-tracker.herokuapp.com/deploys").send_event!
end

task :deploy do
  puts "\tdeploying"
  system "cf push #{application}"
  puts "\tdeployed!"
end
