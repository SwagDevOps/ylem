# frozen_string_literal: true

require 'ylem/cli/base'

# CLI ``start`` command class
class Ylem::Cli::Start < Ylem::Cli::Base
  class << self
    def summary
      'Start up'
    end
  end

  # Get config
  #
  # additional arguments are added to ``config`` as ``:command``
  #
  # @return [Hash]
  def config
    super.merge(command: arguments)
  end
end
