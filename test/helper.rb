# test/helper.rb

require 'minitest/autorun'
require 'minitest-spec-context'
require 'webmock/minitest'
require 'vcr'

require_relative '../lib/statbank_denmark'

VCR.configure do |config|
  config.cassette_library_dir = File.join(__dir__, 'fixtures', 'vcr_cassettes')
  config.hook_into :webmock
  config.default_cassette_options = {record: :once}
  config.allow_http_connections_when_no_cassette = true
end
