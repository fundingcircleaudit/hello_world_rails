set :application, "hello_world_rails"

require "fc-deploy"

before "deploy" do
end

after "deploy" do
  Fc::Deploy::DeployProbe.for(application, "http://localhost:3000/deploys").send_event!
end

task :deploy do
  # system "cf push #{application}"
end
