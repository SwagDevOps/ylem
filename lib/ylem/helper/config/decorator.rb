# frozen_string_literal: true

require 'ylem/helper/config'
require 'ylem/concern/helper'
require 'hash_dot'

# Class intended to decorate config
class Ylem::Helper::Config::Decorator
  include Ylem::Concern::Helper

  # Decorate config
  #
  # @param [Hash] config
  # @return [Hash]
  def decorate(config)
    derived = {
      scripts: {
        path: config.fetch(:scripts_dir),
        executables: list_scripts(config),
      },
      logger: {
        file: config.fetch(:log_file),
      },
      environment: {
        file: config.fetch(:env_file),
        loaded: {},
      },
    }

    config
      .merge(derived)
      .tap do |h|
      [:scripts_dir, :env_file, :log_file].each { |k| h.delete(k) }
    end.to_dot
  end

  protected

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
