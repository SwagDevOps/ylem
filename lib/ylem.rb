# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

# Base module (namespace)
module Ylem
  require 'English'

  # @formatter:off
  {
    VERSION: 'version',
    Action: 'action',
    Bundleable: 'bundleable',
    Cli: 'cli',
    Concern: 'concern',
    GC: 'gc',
    Helper: 'helper',
    Service: 'service',
    Type: 'type',
  }.each { |s, fp| autoload(s, "#{__dir__}/ylem/#{fp}") }
  # @formatter:on

  include(Bundleable)
end
