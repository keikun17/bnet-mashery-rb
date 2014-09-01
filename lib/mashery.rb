require "mashery/version"
require 'open-uri'
require 'json'

require "mashery/configuration"

module Mashery
  def self.configuration
    @configuration ||= Mashery::Configuration.new
  end

  def self.configuration=(configuration)
    @configuration = configuration
  end
end

require "mashery/api"
require 'mashery/account'
require 'mashery/diablo3'
require 'mashery/diablo3/career'
require 'mashery/diablo3/hero'
require 'mashery/diablo3/skill'
# require 'mashery/community'
require 'mashery/starcraft2'
require 'mashery/starcraft2/profile'
require 'mashery/wow'
require 'mashery/wow/data'
require 'mashery/wow/character'

# Separate gem for rails...
# require 'mashery/rails' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
# or as a railtie...
# require 'mashery/railtie' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
