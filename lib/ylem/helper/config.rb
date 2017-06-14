# frozen_string_literal: true

require 'ylem/helper'
require 'ylem/helper/config_reader'

# Config helper
class Ylem::Helper::Config < Ylem::Helper::ConfigReader
  # Default config
  #
  # @return [Hash]
  def defaults
    {
      log_file: Pathname.new('/').join('var', 'log', "#{progname}.log"),
      scripts_dir: Pathname.new(Etc.sysconfdir).join(progname, 'scripts'),
      env_file: Pathname.new(Etc.sysconfdir).join('environment')
    }
  end

  # Parse string content (yaml) merging with defauts
  #
  # @return [Hash|Array]
  def parse(content)
    result = super
    # Apply type has seen from defaults
    defaults.each do |k, v|
      result[k] = Pathname.new(result[k]) if result[k] and v.is_a?(Pathname)
    end

    result
  end
end
