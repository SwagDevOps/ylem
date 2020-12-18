# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'base'

# CLI ``start`` command class
class Ylem::Cli::Start < Ylem::Cli::Base
  class << self
    # Get summary (short description)
    #
    # @return [String]
    def summary
      'Start up'
    end

    # @return [String]
    def banner
      '%<banner>s -- [command]' % {
        banner: super
      }
    end
  end

  def parser
    options.merge!(keep_going: false, verbose: false)

    super
      .on('-k', '--keep-going', 'Keep going even some scripts fails') do |b|
      options[:keep_going] = true
    end
      .on('-v', '--verbose', 'Be verbose') do |b|
      options[:verbose] = true
    end
  end
end
