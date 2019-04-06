require "byebug"
require "bundler/setup"
require "openstax_cnx"
require "dotenv/load"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

OpenStax::Cnx::V1.configure do |config|
  config.archive_url_base = "https://archive.cnx.org"
end

Dir[File.join(__dir__, './support/**', '*.rb')].each { |file| require file }
