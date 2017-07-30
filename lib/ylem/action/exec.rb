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
    begin
      exec(*arguments)
    rescue Errno::ENOENT => e
      on_error(e, e.class.name.split('::')[-1])
    rescue StandardError => e
      on_error(e)
    end
  end

  protected

  # On error
  #
  # @param [StandardError] e
  # @param [Symbol|String] type
  # @return [self]
  def on_error(e, type = :ENOTRECOVERABLE)
    output(e.message, to: :stderr)
    self.retcode = helper.get(:errno).retcode_get(type)

    self
  end
end
