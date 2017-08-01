# frozen_string_literal: true

require 'ylem/action/base'

# Action triggered by CLI ``exec`` command
#
# Replaces the current process by running external command
# (given through arguments)
#
# @see Kernel.exec
# @see https://ruby-doc.org/core-2.4.1/Kernel.html#method-i-exec
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
  # @param [StandardError] error
  # @param [Symbol|String] type
  # @return [self]
  def on_error(error, type = :ENOTRECOVERABLE)
    output(error.message, to: :stderr)
    self.retcode = type

    self
  end
end
