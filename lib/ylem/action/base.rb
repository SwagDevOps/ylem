# frozen_string_literal: true

require 'ylem/action'
require 'active_support/descendants_tracker'

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

  extend ActiveSupport::DescendantsTracker

  # @param [Hash] config
  def initialize(config)
    @config = config
    @retcode = Errno::NOERROR::Errno
  end

  # Execute action
  # @note This method SHOULD be implemented by descendant classes
  #
  # @return [self]
  def execute
    self
  end
end