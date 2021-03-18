# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# ``Cli`` has a progname, replace use of ``$PROGRAM_NAME``.
module Ylem::Concern::Cli::Progname
  class << self
    protected

    def included(*)
      require 'sys/proc'
    end
  end

  # @return [String]
  def progname
    Sys::Proc.progname
  end

  protected

  # @param progname [String]
  #
  # @return [String]
  def progname=(progname)
    Sys::Proc.progname = progname
  end
end
