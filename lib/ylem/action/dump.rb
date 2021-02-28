# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'base'

# Action intended to display parsed (and derivated) config
#
# Derived config is displayed as JSON encoded string
# and cand be accessed using dot notation
#
# @see Ylem.Helper.Config.Decorator
# @see https://github.com/adsteel/hash_dot
class Ylem::Action::Dump < Ylem::Action::Base
  autoload(:JSON, 'json')

  # Get options
  #
  # @return [Hash]
  def options
    super.tap do |options|
      options.merge!(sections: options[:section].to_s.split('.'))
    end
  end

  # Execute action
  #
  # @return [self]
  def execute
    self.tap { output(printable) }
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
  # @return [Hash, Array, Object]
  def dumpable
    config.clone.dup.tap do |dumpable|
      # displays ``scripts.executables`` as relative paths
      dumpable[:scripts][:executables].map!(&:basename)
      # gc seen as boolean
      dumpable[:gc] = !!dumpable[:gc] if dumpable.key?(:gc)
    end.yield_self { |dumpable| walk(dumpable, sections: options.fetch(:sections, [])) }
  end

  # Walk through given dumpable with given sections.
  #
  # @param [Object] dumpable
  # @param [Arrtay<String>] sections
  def walk(dumpable, sections: [])
    sections.each { |section| dumpable = dumpable.public_send(section) }

    dumpable
  end
end
