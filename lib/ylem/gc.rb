# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'

# Minor wrapper on top of `GC`
class Ylem::GC
  # @param [Boolean] enabled
  def initialize(enabled = true)
    # noinspection RubySimplifyBooleanInspection
    @enabled = !!enabled
  end

  # @return [Boolean]
  def enabled?
    @enabled
  end

  # rubocop:disable Metrics/LineLength

  # Initiates garbage collection, unless manually disabled.
  #
  # @param kwargs [Hash] This method is defined with keyword arguments that default to true.
  #
  # Keyword arguments are implementation and version dependent.
  # They are not guaranteed to be future-compatible, and may be ignored if the
  # underlying implementation does not support them.
  #
  # @option kwargs [Symbol] :full_mark ``false`` to perform a minor GC.
  # @option kwargs [Symbol] :immediate_sweep ``false`` to defer sweeping (use lazy sweep).
  #
  # @return [self]
  def start(**kwargs)
    # rubocop:enable Metrics/LineLength
    self.tap do
      ::GC.start(**kwargs) if enabled?
    end
  end
end
