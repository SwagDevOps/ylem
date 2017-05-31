# frozen_string_literal: true

require 'ylem/action'
require 'active_support/descendants_tracker'

# Base action
class Ylem::Action::Base
  attr_reader :config
  extend ActiveSupport::DescendantsTracker

  # @param [Hash]
  def initialize(config = {})
    @config = config
  end
end
