# frozen_string_literal: true

require 'sys/proc'

require 'ylem'
require 'ylem/concern/helper'

class Ylem::Process
  attr_reader :config

  include Ylem::Concern::Helper

  def initialize(config = {})
    Sys::Proc.progname = nil

  end
end
