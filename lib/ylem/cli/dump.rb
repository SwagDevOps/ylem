# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'base'

# CLI ``dump`` command class
class Ylem::Cli::Dump < Ylem::Cli::Base
  class << self
    # Get summary (short description)
    #
    # @return [String]
    def summary
      'Dump configuration (JSON format)'
    end
  end

  def parser
    super.on('--section=SECTION', 'Display section value') do |section|
      options[:section] = section
    end
  end
end
