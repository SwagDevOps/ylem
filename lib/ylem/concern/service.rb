# frozen_string_literal: true

require 'active_support/concern'

require 'ylem/concern'
require 'ylem/service'

# Provides access to system
module Ylem::Concern::Service
  extend ActiveSupport::Concern

  protected

  # @return [Sys::Proc::Helper]
  def service
    Ylem::Service.instance
  end
end
