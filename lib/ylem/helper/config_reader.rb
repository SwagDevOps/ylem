# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../helper'

# Helper intended to read config files
#
# Mostly based on ``Ylem::Helper::Yaml``
class Ylem::Helper::ConfigReader
  autoload(:Pathname, 'pathname')

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
    helper.get('system').path(:etc, progname, 'config.yml')
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
