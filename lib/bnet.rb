require "bnet/version"
require 'open-uri'
require 'json'

require "bnet/configuration"

module Bnet
  def self.configuration
    @configuration ||= Bnet::Configuration.new
  end

  def self.configuration=(configuration)
    @configuration = configuration
  end
end

require "bnet/api"
require "bnet/bnet_resource"
require 'bnet/account'
require 'bnet/diablo3'
require 'bnet/diablo3/career'
require 'bnet/diablo3/item'
require 'bnet/diablo3/hero'
require 'bnet/diablo3/skill'
require 'bnet/diablo3/follower'
# require 'bnet/community' #TODO remove?
require 'bnet/starcraft2'
require 'bnet/starcraft2/ladder'
require 'bnet/starcraft2/match'
require 'bnet/starcraft2/career'
require 'bnet/starcraft2/profile'
require 'bnet/wow'
require 'bnet/wow/data'
require 'bnet/wow/character'

# Separate gem for rails...
# require 'bnet/rails' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
# or as a railtie...
# require 'bnet/railtie' if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
