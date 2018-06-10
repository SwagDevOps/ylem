# frozen_string_literal: true

require_relative '../system'
require 'pathname'

# System path helper
class Ylem::Helper::System::Path
  # Return system root directory
  #
  # @return [Pathname]
  def rootdir
    Pathname.new('/')
  end

  # Return system configuration directory
  #
  # @see https://github.com/pmq20/ruby-compiler/issues/13
  # @return [Pathname]
  def sysconfdir
    rootdir.join('etc')
  end

  # @return [Pathname]
  def vardir
    rootdir.join('var')
  end

  alias etcdir sysconfdir
end
