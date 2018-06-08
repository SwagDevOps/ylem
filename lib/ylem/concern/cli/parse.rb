# frozen_string_literal: true

require_relative '../cli'
require_relative '../cli/output'
require_relative '../helper'
require 'optparse'

# Provide a convenient and reusable way to prepare the ``#run``
#
# Class using this concern MUST define a ``#parse!`` method
#
# ### Sample of use
#
# ```{ruby}
# require 'ylem/concern/cli/parse'
#
# class Ylem::Cli
#   include Ylem::Concern::Cli::Parse
#   # @return [Fixnum]
#   def run
#     parse { do_something }
#   end
# end
# ```
module Ylem::Concern::Cli::Parse
  include Ylem::Concern::Helper
  include Ylem::Concern::Cli::Output

  protected

  # Block to run wrapped CLI method
  #
  # Parse command line arguments (using OptionParser)
  # rescue errors to retcode (integer).
  # When no errors are encountered, given block is executed.
  #
  # @param [Boolean] display_error
  # @yield Execute a given block
  # @yieldreturn [Integer]
  # @return [Integer]
  def parse(display_error = true)
    begin
      parse!
    rescue OptionParser::ParseError => e
      return on_parser_error(e, display_error)
    end

    block_given? ? yield : 0
  end

  # @param [Error] error
  # @param [Boolean] display_error
  # @return [Integer]
  def on_parser_error(error, display_error)
    formatter = lambda do |displayable, code = :EINVAL|
      output(displayable.to_s, to: :stderr) if display_error

      helper.get(:errno).retcode_get(code)
    end

    formatter.call("%<>s\n\n%<>s" % {
      error_name: error.to_s.capitalize,
      parser: parser
    })
  end
end
