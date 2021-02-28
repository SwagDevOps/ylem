# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'

# Namespace for ``Concern``
module Ylem::Concern
  # @formatter:off
  {
    Action: 'action',
    Cli: 'cli',
    Helper: 'helper',
    Output: 'output',
    Service: 'service',
    TimedOutput: 'timed_output',
  }.each { |s, fp| autoload(s, "#{__dir__}/concern/#{fp}") }
  # @formatter:on
end
