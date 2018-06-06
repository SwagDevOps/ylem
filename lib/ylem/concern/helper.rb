# frozen_string_literal: true

require_relative '../concern'
require_relative '../helper'

# Provides access to helpers
module Ylem::Concern::Helper
  protected

  # @return [Sys::Proc::Helper]
  def helper
    Ylem::Helper.instance
  end
end
