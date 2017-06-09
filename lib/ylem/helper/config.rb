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
end
