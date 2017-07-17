# coding: utf-8
# frozen_string_literal: true

require 'ylem/helper'
require 'ylem/helper/config_reader'

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
    sysconfdir = Pathname.new(Etc.sysconfdir)
    rootdir = Pathname.new('/')

    {
      'logger.file':      rootdir.join('var', 'log', "#{progname}.log"),
      'logger.level':     :info,
      'scripts.path':     sysconfdir.join(progname, 'scripts'),
      'environment.file': sysconfdir.join('environment')
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

      if v.is_a?(Pathname)
        result[k] = Pathname.new(result[k])
        result[k] = pwd.join(result[k]) unless result[k].absolute?
      end

      result[k] = result[k].to_sym if v.is_a?(Symbol)
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
