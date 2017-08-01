# frozen_string_literal: true

require 'ylem/action/base'

# Action triggered by CLI ``exec`` command
#
# Replaces the current process by running external command
# (given through arguments)
#
# @see ``Kernel.exec``
class Ylem::Action::Exec < Ylem::Action::Base
  def execute
    Kernel.exec(*command)
  rescue Errno::ENOENT => e
    on_error(e, e.class.name.split('::')[-1])
  rescue StandardError => e
    on_error(e)
  ensure
    self
  end

  # Get command to exec(ute)
  #
  # return [Array<String>]
  def command
    arguments.compact.map(&:to_s)
  end

  protected

  # On error
  #
  # @param [StandardError] e
  # @param [Symbol|String] type
  # @return [self]
  def on_error(e, type = :ENOTRECOVERABLE)
    output(e.message, to: :stderr)
    self.retcode = type

    self
  end
end
