# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../helper'
require 'sys/proc'

# System helper
class Ylem::Helper::System
  include Ylem::Concern::Helper

  # @formatter:off
  {
    Path: 'path',
  }.each { |s, fp| autoload(s, "#{__dir__}/system/#{fp}") }
  # @formatter:on

  # Get program name
  #
  # @return [String]
  def progname
    Sys::Proc.progname
  end

  # Set program name
  def progname=(name)
    Sys::Proc.progname = name
  end

  # Get path for a named target directory
  #
  # @param [Symbol|String] type
  # @param [*Array<String|Object>] parts
  # @return [Pathname]
  # @raise [ArgumentError]
  def path(type, *parts)
    path = helper.get('system/path')
    dirs = path.public_methods
               .grep(/dir$/)
               .map { |method| method.to_s.gsub(/dir$/, '').to_sym }.sort

    unless dirs.include?(type.to_sym)
      raise ArgumentError, "#{type} not in #{dirs}"
    end

    Pathname.new(path.public_send("#{type}dir"))
            .join(*parts.map(&:to_s))
  end
end
