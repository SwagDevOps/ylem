# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../config'
require_relative '../../concern/helper'
require 'hash_dot'
require 'dotenv'

# Class intended to decorate config
class Ylem::Helper::Config::Decorator
  include Ylem::Concern::Helper

  attr_reader :loaded

  def initialize
    @loaded = {}
    # keep track of loaded environment
    @environment = nil
  end

  # Set loaded
  #
  # @param [Hash] config
  def load(config)
    @environment = nil if config != @loaded
    @loaded = config

    self
  end

  # @return [Hash]
  def environment
    if @environment.nil?
      env_file = loaded[:'environment.file']

      @environment = env_file ? Dotenv.load(env_file) : {}
    end

    @environment
  end

  # Decorate loaded (config)
  #
  # @return [Hash]
  def decorate
    original_keys = loaded.keys.delete_if { |key| key =~ /^_/ }

    result = loaded.merge(derived).tap do |h|
      original_keys.each { |k| h.delete(k) }
    end.to_dot

    result.environment.loaded = environment

    result
  end

  protected

  # rubocop:disable Metrics/MethodLength

  # Get base decorated structure
  #
  # @return [Hash]
  def derived
    {
      scripts: {
        path: loaded.fetch(:'scripts.path'),
        executables: list_scripts(loaded),
      },
      logger: {
        file: loaded.fetch(:'logger.file'),
        level: loaded.fetch(:'logger.level').to_s.upcase,
      },
      environment: {
        file: loaded.fetch(:'environment.file'),
        loaded: {},
      },
    }
  end

  # rubocop:enable Metrics/MethodLength

  # List scripts, using ``config[:scripts_dir]``
  #
  # @raise [KeyError] ``scripts_dir``
  # @see Ylem.Helper.Config.ScriptsLister
  # @param [Hash] config
  # @return [Array<Ylem::Type::Script>]
  def list_scripts(config)
    path = config.fetch(:'scripts.path')

    helper.get('config/scripts_lister').configure(path: path).scripts
  end
end
