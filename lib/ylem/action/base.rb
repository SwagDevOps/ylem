# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../action'
require_relative '../concern/helper'
require_relative '../concern/service'
require_relative '../concern/output'

# @abstract Subclass and override {#execute} to implement
#           a custom ``Action`` class.
class Ylem::Action::Base
  # Return code (to be used as status code by command line)
  #
  # @return [Fixnum]
  attr_reader :retcode

  # Options (mostly provided through CLI)
  #
  # @return [Hash]
  attr_reader :options

  # Arguments (mostly provided through CLI)
  #
  # @return [Array]
  attr_reader :arguments

  include Ylem::Concern::Output
  include Ylem::Concern::Helper
  include Ylem::Concern::Service

  # Initialize action
  #
  # @param [Hash] config
  # @param [Hash] options
  def initialize(config, arguments = [], options = {})
    @arguments = arguments
    @options = options
    @config = config

    self.retcode = :NOERROR

    # Forget previous instances of ``Logger`` (during tests)
    # logger service SHOULD not have any instances at this point
    service.get('logger').reset
  end

  # Get config
  #
  # @see Ylem::Helper::Config
  # @return [Hash]
  def config
    helper.get('config/decorator')
          .load(@config)
          .decorate.freeze
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

  # Denote action is a success
  def success?
    helper.get(:errno).retcode_get(:NOERROR) == retcode
  end

  protected

  # Get a self configured ``Logger``
  #
  # @return [Ylem::Service::Logger]
  def logger
    service.get(:logger).configure(self.config.logger)
  end

  # Set retcode
  #
  # ``Symbol`` can be used as param, and resolved from ``Errno``
  # to ``Fixnum (integer)
  #
  # @raise [NameError]
  # @param [Symbol|Fixnum] retcode
  def retcode=(retcode)
    @retcode = helper.get(:errno).retcode_get(retcode)
  end
end
