# frozen_string_literal: true

require_relative '../helper'
require_relative '../concern/helper'
require 'sys/proc'

# System helper
class Ylem::Helper::System
  include Ylem::Concern::Helper

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
