# frozen_string_literal: true

require 'active_support/concern'

require 'ylem/concern/cli'
require 'ylem/concern/output'

# ``Cli`` outputs SHOULD be programmatically deactivable,
# for testing purpose. This concern provides an ``attr_accessor`` to do so.
module Ylem::Concern::Cli::Output
  extend ActiveSupport::Concern
  include Ylem::Concern::Output

  included do
    # Allow/deny access to outputs (``STDOUT``, ``STDERR``)
    #
    # @see Ylem::Concern::Output
    # @return [Boolean]
    attr_accessor :quiet
  end

  # Denote quiet
  #
  # @return [Boolean]
  def quiet?
    !!quiet
  end

  alias dummy_outputs? quiet?
end
