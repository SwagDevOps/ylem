# frozen_string_literal: true

require_relative '../ylem'
require_relative 'concern/helper'
require 'singleton'

# Provides access to service classes
class Ylem::Service
  include ::Singleton
  include Ylem::Concern::Helper

  # @param [String|Symbol] name
  # @return [Object]
  #
  # @raise [NotImplementedError]
  def get(name)
    inflector = helper.get(:inflector)
    name = name.to_sym

    return items[name] if items[name]

    begin
      @items[name] = inflector.resolve("ylem/service/#{name}").new
    rescue LoadError
      raise NotImplementedError, "service not loadable: #{name}"
    end
  end

  class << self
    def method_missing(method, *args)
      super unless respond_to_missing?(method)

      instance.public_send(method, *args)
    end

    def respond_to_missing?(method, include_all = false)
      instance.respond_to?(method, include_all)
    end
  end

  protected

  attr_reader :items

  def initialize
    @items = {}
  end
end
