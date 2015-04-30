class WelcomeController < ApplicationController
  def index
    @revision = ENV.fetch('revision', 'UNKNOWN')
  end
end
