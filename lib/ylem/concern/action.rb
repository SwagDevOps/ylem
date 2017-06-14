# frozen_string_literal: true

require 'ylem/action'
require 'ylem/concern'
require 'active_support/concern'

# Provides access to related action
module Ylem::Concern::Action
  extend ActiveSupport::Concern

  # Get related action
  #
  # @return [Class]
  def action
    from = [Class, Module].include?(self.class) ? self : self.class

    Ylem::Action.from_class(from)
  end

  protected

  # Invoke an action
  #
  # @return [Object]
  def action_execute(*args, &block)
    action.public_send(:new, *args, &block)
  end
end
