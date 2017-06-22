# frozen_string_literal: true

require 'ylem/action/base'
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

    options.merge({
        sections: options[:section].to_s.split('.')
    })
  end

  # Execute action
  #
  # @return [self]
  def execute
    output(printable)

    super
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
  # return [Hash|Array]
  def dumpable
    dumpable = config.clone

    options.fetch(:sections).each do |section|
      dumpable = dumpable.public_send(section)
    end

    dumpable
  end
end
