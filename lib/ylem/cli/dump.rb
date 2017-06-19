# frozen_string_literal: true

require 'ylem/cli/base'

class Ylem::Cli::Dump < Ylem::Cli::Base
  def parser
    parser = super

    parser.on('-k=KEY',
              '--key=KEY',
              'Display key value' % options[:key]) do |key|
        options[:key] = key
    end
  end
end
