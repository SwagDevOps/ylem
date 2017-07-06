# frozen_string_literal: true

require 'ylem/helper'
require 'open3'

# Helper intended to run subprocess (as system command)
#
# A ``::Logger`` can be used as option in order to keep track of execution
# both ``STDOUT`` and ``STDERR`` are logged, with the following levels:
#
# * ``STDOUT`` as ``info``
# * ``STDERR`` as ``warn``
#
# Execution of arbitrary commands is self protected against ``exec``
# by the use of a subshell (``sh -c``), parameters are automagically
# compacted and casted to ``String``.
class Ylem::Helper::Subprocess
  # Run a command
  #
  # @param [Array] command
  # @param [Hash] options
  # @return [Fixnum] as status code
  def run(command, options = {})
    # protect against ``exec``, using ``sh -c``
    command = ['sh', '-c'] + command.to_a.compact.map(&:to_s)
    logger = options[:logger]

    execute_command(command, logger)
  end

  protected

  # rubocop:disable Metrics/MethodLength

  # @param [Array] command
  # @param [::Logger|nil] logger
  # @return [Fixnum] as status code
  def execute_command(command, logger)
    Open3.popen3(*command) do |stdin, out, err, external|
      { out: out, err: err }.each do |source, stream|
        next unless logger

        Thread.new do
          next if (line = stream.gets).nil?

          logger.public_send((source == :out ? :info : :warn), line.chomp)
        end.join
      end

      external.join
      external.value.exitstatus
    end
  end

  # rubocop:enable Metrics/MethodLengt
end
