# frozen_string_literal: true

require 'active_support/concern'

require 'ylem/concern'
require 'ylem/helper'

# Provides access to helpers
module Ylem::Concern::Helper
  extend ActiveSupport::Concern

  protected

  # @return [Sys::Proc::Helper]
  def helper
    Ylem::Helper.instance
  end
end
