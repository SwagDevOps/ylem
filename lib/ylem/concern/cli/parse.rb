# frozen_string_literal: true

require 'ylem/concern/cli'
require 'ylem/concern/helper'
require 'ylem/concern/cli/output'

require 'optparse'
require 'active_support/concern'

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

  # rubocop:disable Metrics/MethodLength

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
    error = lambda do |displayable, code = :EINVAL|
      output(displayable.to_s, to: :stderr) if display_error

      helper.get(:errno).retcode_get(code)
    end

    begin
      parse!
    rescue OptionParser::ParseError => e
      return error.call("%s\n\n%s" % [e.to_s.capitalize, parser])
    end

    block_given? ? yield : 0
  end

  # rubocop:enable Metrics/MethodLength
end
