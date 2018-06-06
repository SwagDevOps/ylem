# frozen_string_literal: true

require_relative '../concern'
require_relative '../service'

# Provides access to ``Ylem::Service``
module Ylem::Concern::Service
  protected

  # @return [Ylem::Service]
  def service
    Ylem::Service.instance
  end
end
