# frozen_string_literal: true

require_relative '../concern'
require_relative '../action'

# Provides access to related action
module Ylem::Concern::Action
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
