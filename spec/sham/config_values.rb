# frozen_string_literal: true

require 'pathname'

# Parsed config values, as ``Ylem::Helper::Config#parse_file()`` result
#
# @see ``config_paths``
# @todo test consistency
#
# Each dataset SHOULD match given config path
Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    {

      success: {
        'logger.file': Pathname.new(SPEC_DIR).join('var/log/success.log'),
        'logger.level': :DEBUG,
        'scripts.path': Pathname.new(SAMPLES_DIR).realpath
                                .join('scripts/success'),
        'environment.file': Pathname.new(SAMPLES_DIR).realpath
                                    .join('environment'),
      },
      failure: {
        'logger.file': Pathname.new(SPEC_DIR).join('var/log/failure.log'),
        'logger.level': :DEBUG,
        'scripts.path': Pathname.new(SAMPLES_DIR).realpath
                                .join('scripts/failure'),
        'environment.file': Pathname.new(SAMPLES_DIR).realpath
                                    .join('environment'),
      }
    }
  end
end
