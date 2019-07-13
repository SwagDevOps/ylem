# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'
require 'singleton'

# Provides access to helper classes
class Ylem::Helper
  include ::Singleton

  # @param [String|Symbol] name
  # @return [Object]
  #
  # @raise [NotImplementedError]
  def get(name)
    name = name.to_sym

    return items[name] if items[name]

    begin
      @items[name] = inflector.resolve("ylem/helper/#{name}").new
    rescue LoadError
      raise NotImplementedError, "helper not loadable: #{name}"
    end
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
