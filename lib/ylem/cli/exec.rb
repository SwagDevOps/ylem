# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'base'
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
      '%<banner>s -- {command}' % {
        banner: super
      }
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
