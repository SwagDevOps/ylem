# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../type'
require_relative '../concern/helper'
require_relative '../concern/timed_output'
require 'pathname'

# Describe a script file
#
# mostly a simple specialization based on ``Pathname``
class Ylem::Type::Script < Pathname
  include Ylem::Concern::Helper
  include Ylem::Concern::TimedOutput

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
  # @see logged_with
  def execute(options = {})
    logger = options[:logger]&.as(public_send(options[:as] || :to_s))

    logged_with(logger, !!options[:debug]) do
      runner.run([self], logger: logger, debug: !!options[:debug]).to_i
    end
  end

  protected

  # Log ``BEGIN``, ``ENDED`` (``debug``) and ``ERROR`` (``error``)
  #
  # Script execution is logged, surrounded by ``BEGIN`` and ``ENDED``
  # when logger severity set to ``DEBUG``.
  # Errors are logged with ``ERROR`` severity.
  # On failure, ``ENDED`` is replaced by ``ERROR``.
  #
  # @param [::Logger] logger
  # @param [Boolean] debug
  # @yieldreturn [::Logger]
  # @return [Integer]
  def logged_with(logger, debug = true)
    logger&.debug('BEGIN')
    timed_output.print("BEGIN: #{self.basename}") if debug

    status = yield logger

    called = {
      true => [:ENDED, :debug],
      false => [:ERROR, :error],
    }.fetch(status.zero?)

    logger&.public_send(called.fetch(1), "#{called.fetch(0)} [#{status}]")
    timed_output.print("ENDED: #{self.basename} [#{status}]") if debug

    status
  end

  # Get script runner (``subprocess``)
  #
  # @return [Ylem::Helper::Subprocess]
  def runner
    helper.get('subprocess')
  end
end
