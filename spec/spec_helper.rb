########## Coveralls ##########

require 'coveralls'
Coveralls.wear! #  Load this ffirst before the tested library

########## Usual things ##########

require 'pry'
require 'bnet'
require 'vcr'
require 'ostruct'
require 'secrets_and_all_that'

VCR.configure do |vcr|
  vcr.cassette_library_dir = 'fixtures/cassettes'
  vcr.default_cassette_options = {record: :once}
  vcr.configure_rspec_metadata!
  vcr.hook_into :webmock
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.failure_color = :magenta

  config.before(:example) do
    Bnet.configuration.api_key = VCR::SECRETS["api_key"]
  end
end
