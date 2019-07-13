# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'base'
require 'json'

# Action intended to display parsed (and derivated) config
#
# Derived config is displayed as JSON encoded string
# and cand be accessed using dot notation
#
# @see Ylem.Helper.Config.Decorator
# @see https://github.com/adsteel/hash_dot
class Ylem::Action::Dump < Ylem::Action::Base
  # Get options
  #
  # @return [Hash]
  def options
    options = super

    options.merge(sections: options[:section].to_s.split('.'))
  end

  # Execute action
  #
  # @return [self]
  def execute
    output(printable)

    self
  end

  # Get printable (JSON encoded string)
  #
  # @return [String]
  def printable
    JSON.pretty_generate(dumpable)
  end

  protected

  # Dumpable content
  #
  # @return [Hash|Array]
  def dumpable
    dumpable = config.clone
    # displays ``scripts.executables`` as relative paths
    dumpable[:scripts][:executables].map!(&:basename)

    options.fetch(:sections).each do |section|
      dumpable = dumpable.public_send(section)
    end

    dumpable
  end
end
