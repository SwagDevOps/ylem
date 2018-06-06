# frozen_string_literal: true

require_relative '../cli'
require_relative '../output'

# ``Cli`` outputs SHOULD be programmatically deactivable,
# for testing purpose. This concern provides an ``attr_accessor`` to do so.
module Ylem::Concern::Cli::Output
  include Ylem::Concern::Output

  # @!attribute [rw] quiet
  #   Allow/deny access to outputs (``STDOUT``, ``STDERR``)
  #   @return [Boolean]
  #   @see Ylem::Concern::Output
  class << self
    def included(base)
      base.class_eval <<-"ACCESSORS", __FILE__, __LINE__ + 1
        attr_accessor :quiet
      ACCESSORS
    end
  end

  # included { attr_accessor :quiet }

  # Denote quiet
  #
  # @return [Boolean]
  def quiet?
    !!quiet
  end

  alias dummy_outputs? quiet?
end
