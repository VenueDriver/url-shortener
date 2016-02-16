require 'vcr'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = {
    :match_requests_on => [:method, :host, :path]
  }
end
