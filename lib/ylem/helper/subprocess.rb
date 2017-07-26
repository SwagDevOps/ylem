# coding: utf-8
# frozen_string_literal: true

require 'ylem/helper'
require 'open3'

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
class Ylem::Helper::Subprocess
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

    run_command(command, options[:logger])
  end

  protected

  # Run a command with logging (where ``logger`` can be ``nil``)
  #
  # @param [Array] command
  # @param [::Logger|nil] logger
  # @return [Fixnum] as status code
  def run_command(command, logger)
    Open3.popen3(*command) do |stdin, stdout, stderr, external|
      stdin.close

      { stdout: stdout, stderr: stderr }
        .map { |source, stream| log_stream(logger, source, stream) }
        .map { |thread| thread&.join }

      external.join
      external.value.exitstatus
    end
  end

  # Log stream outputs (as ``stdout`` or ``stderr``)
  #
  # @param [::Logger|nil] logger
  # @param [Symbol] as
  # @param [IO] stream
  # @return [Thread|nil]
  def log_stream(logger, as, stream)
    severity = { stdout: :info, stderr: :warn }.fetch(as)

    return unless logger

    Thread.new do
      until stream.eof?
        line = stream.gets.strip

        logger.public_send(severity, line) unless line.empty?
      end

      stream.close
    end
  end
end
