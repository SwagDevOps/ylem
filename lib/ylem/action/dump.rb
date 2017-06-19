# frozen_string_literal: true

require 'ylem/action/base'
require 'json'

class Ylem::Action::Dump < Ylem::Action::Base
  def execute
    output = JSON.pretty_generate(config)
    STDOUT.puts(output)

    super
  end

  protected

  def dumpable
    section = options[:key]

    return config if section.nil?
  end
end
