# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../helper'

# Config helper
class Ylem::Helper::Config < Ylem::Helper::ConfigReader
  # Default config
  #
  # @note ``environment.file``: ``/etc/environment``
  #   is used by the ``pam_env`` module and is shell agnostic
  #   so scripting or glob expansion cannot be used.
  #   The file only accepts ``variable=value`` pairs.
  #   See ``pam_env(8)`` and ``pam_env.conf(5)`` for details.
  #
  # @return [Hash]
  def defaults
    os = helper.get('system')

    # @formatter:off
    {
      'logger.file': os.path(:var, 'log', "#{progname}.log"),
      'logger.level': :info,
      'gc.enabled': true,
      'scripts.path': os.path(:etc, progname, 'scripts'),
      'environment.file': os.path(:etc, 'environment')
    }
    # @formatter:on
  end

  def parse_file(filepath = default_file)
    Pathname.new(filepath).tap do |file|
      dir = pwd

      if file.exist?
        dir = file.realpath.dirname
        file = file.realpath
      end

      Dir.chdir(dir) { return super(file) }
    end
  end

  # Parse string content (YAML) merging with defauts
  #
  # @param [String] content
  # @return [Hash]
  def parse(content)
    apply_defaults(super)
  end

  protected

  # Return the current working directory as a Pathname
  #
  # @return [Pathname]
  def pwd
    Pathname.new(Dir.pwd)
  end

  # Apply defaults (typing)
  #
  # Used on a parsed config (from a string/file using YAML format),
  # some values are transformed from original ``String`` type to
  # more advanced types as ``Pathname`` or ``Symbol``
  #
  # @param [Hash] parsed
  # @return [Hash]
  def apply_defaults(parsed)
    result = parsed.clone

    # Apply type has seen from defaults
    defaults.each do |k, v|
      next unless result[k]

      if v.is_a?(Pathname)
        result[k] = Pathname.new(result[k])
        result[k] = pwd.join(result[k]) unless result[k].absolute?
      end

      result[k] = result[k].to_sym if v.is_a?(Symbol)
    end

    result
  end
end
