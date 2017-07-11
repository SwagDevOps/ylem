# frozen_string_literal: true

require 'active_support/concern'

require 'ylem/concern/cli'
require 'ylem/concern/output'

# ``Cli`` outputs SHOULD be programmatically deactivable,
# for testing purpose. This concern provides an ``attr_accessor`` to do so.
module Ylem::Concern::Cli::Output
  extend ActiveSupport::Concern
  include Ylem::Concern::Output

  # @!attribute [rw] quiet
  #   Allow/deny access to outputs (``STDOUT``, ``STDERR``)
  #   @return [Boolean]
  #   @see Ylem::Concern::Output
  included { attr_accessor :quiet }

  # Denote quiet
  #
  # @return [Boolean]
  def quiet?
    !!quiet
  end

  alias dummy_outputs? quiet?
end
