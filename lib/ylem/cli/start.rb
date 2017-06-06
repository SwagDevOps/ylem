# frozen_string_literal: true

require 'ylem/cli/base'

class Ylem::Cli::Start < Ylem::Cli::Base
  # Read config
  #
  # additional arguments are added to ``config`` as ``:command``
  #
  # @return [Hash]
  def config
    super.merge({command: arguments})
  end
end
