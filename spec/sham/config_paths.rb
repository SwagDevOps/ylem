# frozen_string_literal: true

require 'securerandom'

# Paths to success + failure configuration files
#
# default config path is a pattern, as progname is dynamic
Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {
      success: "#{SAMPLES_DIR}/config/success.yml",
      failure: "#{SAMPLES_DIR}/config/failure.yml",
      partial: "#{SAMPLES_DIR}/config/partial.yml",
      empty: "#{SAMPLES_DIR}/config/empty.yml",
      default: %r{^/etc/(rake|rspec)/config\.yml$},
      randomizer: lambda do
        [
          nil,
          SecureRandom.hex(1),
          SecureRandom.hex(2),
          SecureRandom.hex(3),
          'config.yml'
        ].join('/')
      end
    }
  end
end
