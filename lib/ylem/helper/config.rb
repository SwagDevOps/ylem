# frozen_string_literal: true

require 'ylem/helper'
require 'ylem/concern/helper'
require 'etc'
require 'pathname'

# Config helper
class Ylem::Helper::Config
  include Ylem::Concern::Helper

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

  # Default config file
  #
  # @return [Pathname]
  def default_file
    Pathname.new(Etc.sysconfdir).join(progname, 'config.yml')
  end

  def default_file?(filepath)
    Pathname.new(filepath) == default_file
  end

  # Parse comfig (yaml) file
  #
  # @param [Pathname|String] filepath
  # @return [Hash]
  def parse_file(filepath = default_file)
    filepath = Pathname.new(filepath)

    if default_file?(filepath) and !filepath.exist?
      return defaults
    end

    parse(filepath.read)
  end

  # Parse string content (yaml) merging with defauts
  #
  # @return [Hash|Array]
  def parse(content)
    parsed = helper.get('yaml').parse(content)

    # @todo raise explicit exception before merge
    result = defaults.merge(parsed)
    defaults.each do |k, v|
      result[k] = Pathname.new(result[k]) if result[k] and v.is_a?(Pathname)
    end

    result
  end

  protected

  # @return [String]
  def progname
    helper.get('system').progname
  end
end
