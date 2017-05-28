# frozen_string_literal: true

require 'ylem/concern'

require 'active_support/concern'

# Provides access to related action
module Ylem::Concern::Action
  extend ActiveSupport::Concern

  # @return [Class]
  def action
    require 'ylem/action'

    Ylem::Action.from_class(self.class)
  end

  protected

  # Invoke an action
  #
  # @return [Object]
  def action_execute(*args, &block)
    action.public_send(:new, *args, &block)
  end
end
