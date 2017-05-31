# frozen_string_literal: true

require 'ylem/helper'
require 'sys/proc'

# System helper
class Ylem::Helper::System
  # Get program name
  #
  # @return [String]
  def progname
    Sys::Proc.progname
  end

  # Set program name
  def progname=(name)
    Sys::Proc.progname = name
  end
end
