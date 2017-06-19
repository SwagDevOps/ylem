# frozen_string_literal: true

require 'ylem/helper/config'
require 'ylem/concern/helper'
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
      env_file = loaded[:env_file]

      @environment = env_file ? Dotenv.load(env_file) : {}
    end

    @environment
  end

  # Decorate loaded (config)
  #
  # @return [Hash]
  def decorate
    result = loaded
      .merge(derived)
      .tap do |h|
      [:scripts_dir, :env_file, :log_file].each { |k| h.delete(k) }
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
        path: loaded.fetch(:scripts_dir),
        executables: list_scripts(loaded),
      },
      logger: {
        file: loaded.fetch(:log_file),
      },
      environment: {
        file: loaded.fetch(:env_file),
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
    path = config.fetch(:scripts_dir)

    helper.get('config/scripts_lister').configure(path: path).scripts
  end
end