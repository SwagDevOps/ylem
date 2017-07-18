# frozen_string_literal: true

require 'active_support/concern'

require 'ylem/concern/cli'
require 'ylem/concern/helper'
require 'ylem/concern/cli/output'

# Provide a convenient and reusable way to prepare the ``#run``
#
# Class using this concern MUST define a ``#parse!`` method
module Ylem::Concern::Cli::ParsedRun
  include Ylem::Concern::Helper
  include Ylem::Concern::Cli::Output

  protected

  # Block to run wrqpped CLI method
  #
  # Parse command line qrguments (using OptionParser)
  # rescue errors to retcode (integer).
  # When no errors are encountered, given block is executed.
  #
  # @yield Execute a wrapped method
  # @yieldreturn [Integer]
  # @return [Integer]
  def parsed_run
    yield if proc do
      begin
        parse!
      rescue OptionParser::InvalidOption, OptionParser::InvalidArgument
        parsed_error(parser)
      rescue OptionParser::MissingArgument => e
        parsed_error(e)
      else
        0
      end
    end.call.zero?
  end

  # Display error (displayable) on ``STDERR`` and return retcode
  #
  # @param [String|Object] displayable
  # @param [Symbol] code
  # @return [Integer]
  def parsed_error(displayable, code = :EINVAL)
    output(displayable.to_s, to: :stderr)

    helper.get(:errno).retcode_get(code)
  end
end
