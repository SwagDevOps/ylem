# frozen_string_literal: true

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
