# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'
require_relative '../helper'

# Provides access to helpers
module Ylem::Concern::Helper
  protected

  # @return [Sys::Proc::Helper]
  def helper
    Ylem::Helper.instance
  end
end
