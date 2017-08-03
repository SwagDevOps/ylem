# frozen_string_literal: true

require 'ylem/helper/system'
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
  # @return [Pathname]
  # @see https://github.com/pmq20/ruby-compiler/issues/13
  def sysconfdir
    rootdir.join('etc')
  end

  alias etcdir sysconfdir
end
