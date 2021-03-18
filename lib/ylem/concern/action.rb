# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'
require_relative '../action'

# Provides access to related action
module Ylem::Concern::Action
  # Get related action
  #
  # @return [Class<Ylem::Action::Base>]
  def action
    ([Class, Module].include?(self.class) ? self : self.class).tap do |from|
      return Ylem::Action.from_class(from)
    end
  end

  protected

  # Invoke an action
  #
  # @return [Object]
  def action_execute(*args, &block)
    action.public_send(:new, *args, &block)
  end
end
