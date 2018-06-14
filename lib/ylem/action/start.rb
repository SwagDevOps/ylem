# frozen_string_literal: true

require_relative 'base'
require_relative '../concern/timed_output'
require 'open3'

# Action triggered by CLI ``start`` command
#
# This action will execute scripts (listed as ``executables`` by ``config``)
# one by one, procedurally. At the end, ``retcode`` denote
# any error issued during scripts execution.
# In this case, a ``retcode`` equal to
# ``Errno::ENOTRECOVERABLE::Errno`` (``131``) is used.
class Ylem::Action::Start < Ylem::Action::Base
  include Ylem::Concern::TimedOutput

  # @return [self]
  def execute
    with_print_execution_status do
      Thread.abort_on_exception = true

      execute_scripts(scripts)
    end

    self.exec(command)
  end

  # Get scripts (to be executed)
  #
  # @return [Array<Ylem::Type::Script>]
  def scripts
    config.scripts.executables
  end

  # Get command
  #
  # @return [Array]
  def command
    arguments.compact.map(&:to_s).freeze
  end

  # Denote command (not empty)
  #
  # @return [Boolean]
  def command?
    !command.empty?
  end

  # Keep going even some scripts fails
  #
  # @return [Boolean]
  def keep_going?
    !!options[:keep_going]
  end

  # @return [Boolean]
  def verbose?
    !!options[:verbose]
  end

  def script_options
    {
      logger: logger,
      as: :basename,
      debug: verbose?
    }
  end

  protected

  # Execute scripts
  #
  # @param [Array<Ylem::Type::Script>] scripts
  # @return [self]
  def execute_scripts(scripts)
    scripts.each do |script|
      # rubocop:disable Style/Next
      unless script.execute(script_options).zero?
        self.retcode = :ENOTRECOVERABLE

        return self unless keep_going?
      end
      # rubocop:enable Style/Next
    end

    self
  end

  # Exec command (``arguments``)
  #
  # @note as ``exec`` success will replace current process
  #       it can hide previous exit code,
  #       hiding errors encoutered during scripts execution.
  #
  # @param [Array] command
  # @return [self]
  # @see Ylem::Action::Exec
  def exec(command)
    action = Ylem::Action.get(:exec)

    if command? and (success? or keep_going?)
      action.new(@base_config, command, options).execute
      # As ``exec`` will replace current process
      # it can hide previous exit code
      self.retcode = success? ? action.retcode : self.retcode
    end

    self
  end

  # @return [self]
  def with_print_execution_status
    self.timed_output.time { yield(self) }
    print_execution_status if verbose?

    self
  end

  # @return [self]
  def print_execution_status
    status_line = 'Executed (with %<status>s) in %<time>.06fs [%<retcode>s]'
    # rubocop:disable Style/NestedTernaryOperator
    timed_output.print(status_line % {
      time: timed_output.elapsed,
      status: success? ? 'success' : 'failure',
      retcode: success? ? retcode : (keep_going? ? 0 : retcode),
    })
    # rubocop:enable Style/NestedTernaryOperator
    self
  end
end
