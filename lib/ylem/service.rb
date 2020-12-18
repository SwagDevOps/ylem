# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
