# frozen_string_literal: true

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
    super
      .on('--section=SECTION', 'Display section value') do |section|
      options[:section] = section
    end
  end
end
