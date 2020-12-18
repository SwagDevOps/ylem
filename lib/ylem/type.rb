# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'

# Namespace for type(s)
module Ylem::Type
  # @formatter:off
  {
    OptionParser: 'option_parser',
    Script: 'script',
  }.each { |s, fp| autoload(s, "#{__dir__}/type/#{fp}") }
  # @formatter:on
end
