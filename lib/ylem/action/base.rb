# frozen_string_literal: true

require 'ylem/action'
require 'ylem/concern/helper'
require 'ylem/concern/service'
require 'ylem/concern/output'
require 'active_support/descendants_tracker'
require 'hash_dot'
require 'stringio'

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

  # Options (mostly provided through CLI)
  #
  # @return [Hash]
  attr_reader :options

  extend ActiveSupport::DescendantsTracker
  include Ylem::Concern::Output
  include Ylem::Concern::Helper
  include Ylem::Concern::Service

  # Initialize action
  #
  # @param [Hash] config
  # @param [Hash] options
  def initialize(config, options = {})
    @options = options
    @config = helper.get('config/decorator').load(config).decorate.freeze
    @retcode = Errno::NOERROR::Errno
  end

  # @return [Booolean]
  # @see Ylem.Concern.Output#dummy_outputs?
  def dummy_outputs?
    options[:quiet]
  end

  # Execute action
  # @note This method SHOULD be implemented by descendant classes
  #
  # @return [self]
  def execute
    self
  end

  protected

  # Get a self configured ``Logger``
  #
  # @return [Ylem::Service::Logger]
  def logger
    service.get(:logger).configure(self.config.logger)
  end
end
