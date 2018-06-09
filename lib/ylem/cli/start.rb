# frozen_string_literal: true

require_relative 'base'

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
      '%<banner>s -- [command]' % {
        banner: super
      }
    end
  end
end
