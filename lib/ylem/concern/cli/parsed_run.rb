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
    begin
      parse!
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument
      output(parser, to: :stderr)

      return helper.get(:errno).retcode_get(:EINVAL)
    rescue OptionParser::MissingArgument => e
      output(e, to: :stderr)

      return helper.get(:errno).retcode_get(:EINVAL)
    end

    yield
  end
end
