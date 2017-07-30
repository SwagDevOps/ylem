# frozen_string_literal: true

require 'ylem/cli/base'

# CLI ``start`` command class
class Ylem::Cli::Start < Ylem::Cli::Base
  class << self
    # Get summary (short description)
    #
    # @return [String]
    def summary
      'Start up'
    end

    # @return [String]
    def banner
      '%s -- [command]' % super
    end
  end
end
