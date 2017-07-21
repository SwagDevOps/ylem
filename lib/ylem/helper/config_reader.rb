# frozen_string_literal: true

require 'ylem/helper'
require 'ylem/concern/helper'
require 'etc'
require 'pathname'

# Helper intended to read config files
#
# Mostly based on ``Ylem::Helper::Yaml``
class Ylem::Helper::ConfigReader
  include Ylem::Concern::Helper

  # Default config
  #
  # @return [Hash]
  def defaults
    {}
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

    parse(filepath.read)
  end

  # Parse string content (yaml) merging with defauts
  #
  # @return [Hash|Array]
  def parse(content)
    parsed = helper.get('yaml').parse(content)

    # @todo raise explicit exception before merge
    defaults.merge(parsed.to_h)
  end

  protected

  # @return [String]
  def progname
    helper.get('system').progname
  end
end
