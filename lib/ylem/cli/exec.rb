# frozen_string_literal: true

require 'ylem/cli/base'

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
end
