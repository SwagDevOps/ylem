# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../helper'

# Helper intended to run subprocess (as ``Kernel#system``)
#
# A ``::Logger`` can be used as option in order to keep track of execution
# both ``STDOUT`` and ``STDERR`` are logged, with the following levels:
#
# * ``STDOUT`` as ``info``
# * ``STDERR`` as ``warn``
#
# Execution of arbitrary commands is self protected against
# [``exec``](https://linux.die.net/man/3/exec)
# by the use of a subshell (``sh -c``), parameters are automagically
# compacted and casted to ``String``.
#
# @todo Implement verbose
class Ylem::Helper::Subprocess
  include Ylem::Concern::TimedOutput

  autoload(:Open3, 'open3')
  # @formatter:off
  {
    Manager: 'manager',
    Streamer: 'streamer',
  }.each { |s, fp| autoload(s, "#{__dir__}/subprocess/#{fp}") }
  # @formatter:on

  def initialize
    @severities = { stdout: :info, stderr: :warn }
    @external = nil
  end

  # Run a command
  #
  # returns error status as ``Fixnum`` (``0`` is success)
  #
  # @param [Array] command
  # @param [Hash] options
  # @return [Fixnum] as status code
  def run(command, options = {})
    # protect against ``exec``, using ``sh -c``
    command = ['sh', '-c'] + command.to_a.compact.map(&:to_s)

    run_command(command, options[:logger], !!options[:debug])
  end

  protected

  # Get severities
  #
  # Indexed by output, as: ``{ stdout: :info, stderr: :warn }``
  #
  # @return [Hash]
  attr_reader :severities

  # Run a command with logging (where ``logger`` can be ``nil``)
  #
  # @param [Array] command
  # @param [::Logger|nil] logger
  # @param [Boolean] debug
  # @return [Fixnum] as status code
  def run_command(command, logger, debug = false)
    Open3.popen3(*command) do |stdin, stdout, stderr, external|
      stdin.close
      external.tap { Manager.new(external) }.tap do
        { stdout: stdout, stderr: stderr }
          .map { |source, stream| log_stream(logger, source, stream, debug) }
          .map { |thread| thread&.join }

        external.join
      end.value.exitstatus
    end
  end

  # Log stream outputs (as ``stdout`` or ``stderr``)
  #
  # @param [::Logger|nil] logger
  # @param [Symbol] source
  # @param [IO] stream
  # @param [Boolean] debug
  # @return [Thread|nil]
  def log_stream(logger, source, stream, debug = false)
    severity = severities.fetch(source)

    return unless logger

    log(logger, severity, stream, debug)
  end

  def log(logger, severity, stream, debug = false)
    stream = Streamer.new(stream)

    Thread.new do |thr|
      until stream.eof?
        line = stream.gets.strip

        logger.public_send(severity, line)
        timed_output.print(line, to: fetch_output(severity)) if debug
      end
      stream.close
    end
  end

  # Fetch output by given severity
  #
  # @param [Symbol] severity
  # @return [Symbol]
  def fetch_output(severity)
    severities.invert.fetch(severity)
  end

  # @return [Process::Waiter]
  #
  # @see https://ruby-doc.org/core-2.3.0/Thread.html
  # @see https://ruby-doc.org/core-2.3.0/Process/Waiter.html
  attr_accessor :external
end
