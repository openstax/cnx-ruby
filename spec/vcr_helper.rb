require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  c.preserve_exact_body_bytes { |http_message| !http_message.body.valid_encoding? }

  # Turn on debug logging, works in Travis too tho in full runs results
  # in Travis build logs that are too large and cause a Travis error
  # c.debug_logger = $stderr
end

def vcr_friendly_uuids(count:, namespace: '')
  uuids = count.times.map{ SecureRandom.uuid }
  VCR.configure do |config|
    uuids.each_with_index do |uuid,ii|
      config.define_cassette_placeholder("<UUID_#{namespace}_#{ii}>") { uuid }
    end
  end
  uuids
end

VCR_OPTS = {
  # This should default to :none
  record: ENV.fetch('VCR_OPTS_RECORD', :none).to_sym,
  allow_unused_http_interactions: false
}
