# frozen_string_literal: true

require_relative '../ylem'
require 'singleton'

# Provides access to helper classes
class Ylem::Helper
  include ::Singleton

  # @param [String|Symbol] name
  # @return [Object]
  def get(name)
    name = name.to_sym

    return items[name] if items[name]

    @items[name] = inflector.resolve("ylem/helper/#{name}").new
  end

  protected

  # @return [Hash]
  attr_reader :items

  def initialize
    @items = {
      inflector: proc do
        require 'ylem/helper/inflector'

        Inflector.new
      end.call
    }

    super
  end

  # @return [Hash]
  def to_h
    items
  end

  # @return [Sys::Proc::Helper::Inflector]
  def inflector
    to_h.fetch(:inflector)
  end
end
