# frozen_string_literal: true

require 'ylem/helper/config'
require 'ylem/concern/helper'
require 'hash_dot'

# Class intended to decorate config
class Ylem::Helper::Config::Decorator
  include Ylem::Concern::Helper

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

  # @see [Ylem::Helper::Config::Scripts_Lister]
  # @param [Hash] config
  # @return [Array]
  def list_scripts(config)
    path = config.fetch(:scripts_dir)

    helper.get('config/scripts_lister').configure(path: path).scripts
  end
end
