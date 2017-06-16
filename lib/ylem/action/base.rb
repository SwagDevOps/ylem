# frozen_string_literal: true

require 'ylem/action'
require 'ylem/concern/helper'
require 'active_support/descendants_tracker'
require 'dotenv'

# @abstract Subclass and override {#execute} to implement
#           a custom ``Action`` class.
class Ylem::Action::Base
  # Config as seen in ``Ylem::Helper::Config``
  #
  # @see Ylem::Helper::Config
  # @return [Hash]
  attr_reader :config

  # Return code (to be used as status code by command line)
  #
  # @return [Fixnum]
  attr_reader :retcode

  # Return loaded environment
  #
  # @return [Hash]
  attr_reader :loaded_environment

  extend ActiveSupport::DescendantsTracker

  include Ylem::Concern::Helper

  # @param [Hash] config
  def initialize(config)
    @loaded_environment = {}
    @config = helper.get('config/decorator').decorate(config)
    @retcode = Errno::NOERROR::Errno
  end

  # Execute action
  # @note This method SHOULD be implemented by descendant classes
  #
  # @return [self]
  def execute
    @loaded_environment = load_environment

    self
  end

  protected

  # @return [Hash]
  def load_environment
    Dotenv.load(config[:env_file]) if config[:env_file]
  end
end
