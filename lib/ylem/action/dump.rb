# frozen_string_literal: true

require 'ylem/action/base'
require 'json'

class Ylem::Action::Dump < Ylem::Action::Base
  # Execute action
  #
  # @return [self]
  def execute
    STDOUT.puts(output)

    super
  end

  # Get output (JSON encoded string)
  #
  # @return [String]
  def output
    JSON.pretty_generate(dumpable)
  end

  protected

  def dumpable
    dumpable = config
    sections = options[:key].to_s.split('.')

    unless sections.empty?
      sections.each do |section|
        dumpable = dumpable.public_send(section)
      end
    end

    dumpable
  end
end
