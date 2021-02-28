# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'base'

# Action triggered by CLI ``exec`` command
#
# Replaces the current process by running external command
# (given through arguments)
#
# @see Kernel.exec
# @see https://ruby-doc.org/core-2.4.1/Kernel.html#method-i-exec
class Ylem::Action::Exec < Ylem::Action::Base
  def execute
    gc.start

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
