# frozen_string_literal: true

require 'ylem/cli/base'

class Ylem::Cli::Dump < Ylem::Cli::Base
  class << self
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
