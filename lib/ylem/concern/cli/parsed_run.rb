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

  # rubocop:disable Metrics/MethodLength

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
    error = lambda { |displayable, code = :EINVAL|
      output(displayable.to_s, to: :stderr)

      helper.get(:errno).retcode_get(code)
    }

    yield if proc do
      begin
        parse!
      rescue OptionParser::InvalidOption, OptionParser::InvalidArgument
        error.call(parser)
      rescue OptionParser::MissingArgument => e
        error.call(e)
      else
        0
      end
    end.call.zero?
  end

  # rubocop:enable Metrics/MethodLength
end
