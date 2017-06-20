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
  # Execute action
  #
  # @return [self]
  def execute
    STDOUT.puts(output)

    super
  end

  # Get output (JSON encoded string)
  #
  # @return [String]
  def output
    JSON.pretty_generate(dumpable)
  end

  protected

  # Dumpable content
  #
  # return [Hash|Array]
  def dumpable
    dumpable = config

    queried_sections.each do |section|
      args = [section, []]
      # args = ['[]', /^[0-9]{1,}$/ =~ section ? section.to_i : section] \
      # if dumpable.is_a?(Array)

      dumpable = dumpable.public_send(*args)
    end

    dumpable
  end

  # Get requested section(s), ``options`` based
  #
  # @return [Hash<String>]
  def queried_sections
    options[:section].to_s.split('.')
  end
end
