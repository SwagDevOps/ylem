# frozen_string_literal: true

require 'ylem/cli/base'

require 'optparse'

# CLI ``exec`` command class
class Ylem::Cli::Exec < Ylem::Cli::Base
  class << self
    # Get summary (short description)
    #
    # @return [String]
    def summary
      'Run the given external command'
    end

    # @return [String]
    def banner
      '%s -- {command}' % super
    end
  end

  # @raise [OptionParser::MissingArgument]
  # @see Ylem::Cli::Base#parse!
  # @return [self]
  def parse!
    super

    if arguments.to_a.empty?
      message = 'given 0, expected 1+'

      raise OptionParser::MissingArgument, message
    end

    self
  end
end
