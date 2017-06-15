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

  def parse_file(filepath = default_file)
    filepath = Pathname.new(filepath)
    dir = pwd
    parsed = {}

    if filepath.exist?
      dir = filepath.realpath.dirname
      filepath = filepath.realpath
    end

    Dir.chdir(dir) { parsed = super }
  end

  # Parse string content (yaml) merging with defauts
  #
  # @return [Hash|Array]
  def parse(content)
    result = super
    # Apply type has seen from defaults
    defaults.each do |k, v|
      next unless result[k]
      next unless v.is_a?(Pathname)

      result[k] = Pathname.new(result[k])
      result[k] = pwd.join(result[k]) unless result[k].absolute?
    end

    result
  end

  protected

  # Return the current working directory as a Pathname
  #
  # @return [Pathname]
  def pwd
    Pathname.new(Dir.pwd)
  end
end
