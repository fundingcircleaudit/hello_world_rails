require "capistrano/snowden"

set :application, "hello_world_rails"

before "deploy" do
end

after "deploy" do
  Capistrano::Snowden::DeployProbe.for(
    application: "#{application}",
    endpoint_url: "http://localhost:3000/"
  ).send_event!
end

task :deploy do
  # system "cf push #{application}"
end
