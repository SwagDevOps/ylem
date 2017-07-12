# frozen_string_literal: true

require 'ylem/helper'

# Helper on top of ``Errno``
class Ylem::Helper::Errno
  # Get a system error number
  #
  # The integer operating system error number corresponding
  # to a particular error is available as the class constant
  # ``Errno::error::Errno``.
  #
  # @raise [RuntimeError]
  # @param [Symbol|Object] retcode
  # @return [Integer]
  def retcode_get(retcode)
    constants = Errno.constants
    if retcode.is_a?(String) and constants.map(&:to_s).include?(retcode)
      retcode = retcode.to_sym
    end

    if retcode.is_a?(Symbol)
      retcode = Errno.const_get(retcode.to_s.upcase)::Errno
    end

    return retcode if retcode.is_a?(Integer)

    raise "Unexpected value: #{retcode.inspect}"
  end
end
