# frozen_string_literal: true

require_relative 'base'
require 'open3'

# Action triggered by CLI ``start`` command
#
# This action will execute scripts (listed as ``executables`` by ``config``)
# one by one, procedurally. At the end, ``retcode`` denote
# any error issued during scripts execution.
# In this case, a ``retcode`` equal to
# ``Errno::ENOTRECOVERABLE::Errno`` (``131``) is used.
class Ylem::Action::Start < Ylem::Action::Base
  def execute
    unless execute_scripts(scripts).success?
      output('An error was encountered while executing scripts', to: :stderr)
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

  protected

  # Execute scripts
  #
  # @param [Array<Ylem::Type::Script>] scripts
  def execute_scripts(scripts)
    scripts.each do |script|
      # rubocop:disable Style/Next
      unless script.execute(logger: logger, as: :basename).zero?
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

    if command?
      action.new(@base_config, command, options).execute
      # As ``exec`` will replace current process
      # it can hide previous exit code
      self.retcode = success? ? action.retcode : self.retcode
    end

    self
  end
end
