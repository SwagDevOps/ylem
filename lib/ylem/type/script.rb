# frozen_string_literal: true

require 'ylem/type'
require 'pathname'
require 'ylem/concern/helper'

# Describe a script file
#
# mostly a simple specialization based on ``Pathname``
class Ylem::Type::Script < Pathname
  include Ylem::Concern::Helper

  # Denote is a script (executable file)
  #
  # @return [Boolean]
  def script?
    self.file? and self.executable? and self.readable?
  end

  # Execute itself
  #
  # Script is responsible to execute itself, executing a non-executable or
  # inexistent script SHOULD return a ``127`` status
  #
  # @param [Hash] options
  # @option options [Ylem::Service::Logger] :logger
  # @option options [Symbol|String] :as
  #   method applied on instance (example: ``:basename``)
  #   identify itself with ``logger``
  #
  # @return [Fixnum]
  def execute(options = {})
    logger = options[:logger]&.as(public_send(options[:as] || :to_s))
    runner = helper.get('subprocess')

    logged_with(logger) { runner.run([self], logger: logger).to_i }
  end

  protected

  # Log ``BEGIN``, ``ENDED`` (``debug``) and ``ERROR`` (``error``)
  #
  # Script execution is logged, surrounded by ``BEGIN`` and ``ENDED``
  # when logger severity set to ``DEBUG``. Errors are logged with
  # ``ERROR`` severity.
  #
  # @param [::Logger] logger
  # @yieldreturn [::Logger]
  # @return [Integer]
  def logged_with(logger)
    logger&.debug('BEGIN')
    status = yield logger
    logger&.debug("ENDED [#{status}]")
    logger&.error("ERROR [#{status}]") unless status.zero?

    status
  end
end
