# frozen_string_literal: true

require_relative '../concern'
require 'stringio'

# Provides access to outputs (``STDOUT`` and ``STDERR``)
#
# Default outputs are defined as ``STDOUT`` and ``STDERR``
# and evaluated on demand.
#
# Outputs cand be muted (all at once), using ``dummy_outputs?`` method,
# default is ``false``, extending class COULD redefine this method.
module Ylem::Concern::Output
  # Output message (using defined outputs)
  #
  # @param [String] message
  # @param [Hash] options
  def output(message, options = {})
    options = {
      to: :stdout,
      method: :puts
    }.merge(options)

    stream = outputs.fetch(options.fetch(:to))

    stream.public_send(options.fetch(:method), message)
  end

  # Denote dummy outputs (dummy writable IOs) are used
  #
  # @return [Boolean]
  def dummy_outputs?
    false
  end

  def dummy_outputs
    outputs = internal_outputs

    # Replace all outputs by a dummy writable IO, on demand
    #
    # could use ``File.open(File::NULL, "w")`` too
    outputs.each { |k, v| outputs[k] = StringIO.new }

    outputs
  end

  # Get outputs
  #
  # @return [Hash]
  def outputs
    dummy_outputs? ? dummy_outputs : internal_outputs
  end

  protected

  # Default outputs
  #
  # @return [Hash]
  def default_outputs
    {
      stdout: STDOUT,
      stderr: STDERR,
    }
  end

  # Get outputs, considering ``@outputs``
  #
  # @return [Hash]
  def internal_outputs
    (@outputs || default_outputs).clone
  end
end
