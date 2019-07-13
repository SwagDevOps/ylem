# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'
require_relative 'helper'

# Concern for timed output
#
# @see Ylem::Helper::TimedOutput
module Ylem::Concern::TimedOutput
  include Ylem::Concern::Helper

  protected

  # Get output
  #
  # @return Ylem::Helper::TimedPrinter
  def timed_output
    printer = helper.get(:timed_output)
    if self.respond_to?(:dummy_outputs?)
      printer.quiet = dummy_outputs?
    end

    printer
  end
end
