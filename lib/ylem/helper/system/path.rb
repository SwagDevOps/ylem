# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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
