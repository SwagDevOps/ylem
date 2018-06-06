# frozen_string_literal: true

require_relative '../helper'
require 'dry/inflector'

# Inflector built on top of ``Dry::Inflector``
class Ylem::Helper::Inflector
  def initialize
    @inflector = Dry::Inflector.new
  end

  # Load constant from a loadable/requirable path
  #
  # @param [String] loadable
  # @return [Object]
  def resolve(loadable)
    loadable = loadable.to_s.empty? ? nil : loadable.to_s

    require loadable

    @inflector.constantize(@inflector.classify(loadable))
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      @inflector.public_send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    return true if @inflector.respond_to?(method, include_private)

    super(method, include_private)
  end
end
