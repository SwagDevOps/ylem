# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
      stdout: $stdout,
      stderr: $stderr,
    }
  end

  # Get outputs, considering ``@outputs``
  #
  # @return [Hash]
  def internal_outputs
    (@outputs || default_outputs).clone
  end
end
