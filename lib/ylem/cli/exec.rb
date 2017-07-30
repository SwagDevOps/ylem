# frozen_string_literal: true

require 'ylem/cli/base'
require 'ylem/cli/start'

# CLI ``start`` command class
class Ylem::Cli::Exec < Ylem::Cli::Start
  class << self
    # Get summary (short description)
    #
    # @return [String]
    def summary
      'Run the given external command'
    end
  end
end
