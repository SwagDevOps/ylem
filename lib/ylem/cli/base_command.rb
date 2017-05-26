# frozen_string_literal: true

require 'ylem/concern/helper'
require 'etc'
require 'optparse'
require 'pathname'

class Ylem::Cli::BaseCommand
  attr_reader :argv
  attr_reader :options
  attr_reader :arguments

  class << self
    include Ylem::Concern::Helper

    # Default options
    #
    # @return [Hash]
    def defaults
      {
        config: Pathname.new(Etc.sysconfdir)
                        .join($PROGRAM_NAME, 'config.yml')
      }
    end

    # Command description
    #
    # SHOULD be overriden by child class
    #
    # @return [String]
    def to_s
      name
    end

    # @return [String]
    def banner
      keyword = helper.get(:inflector).underscore(name.split('::')[-1])

      'Usage: %s %s [options]' % [$PROGRAM_NAME, keyword]
    end
  end

  # @param [Array] argv
  def initialize(argv = ARGV)
    @argv = argv.clone
    @options = self.class.defaults
    @arguments = []
  end

  def parser
    options = @options # {}
    OptionParser.new do |opts|
      opts.banner = self.class.banner

      opts.on('-c=CONFIG',
              '--config=CONFIG',
              'Config file used [%s]' % options[:config]) do |c|
        options[:config] = c
      end
    end
  end

  # @return [self]
  def parse!
    argv = self.argv.clone

    begin
      parser.parse!(argv)
    rescue OptionParser::InvalidOption
      STDERR.puts(parser)
      exit(Errno::EINVAL::Errno)
    end
    @options = @options
    @arguments = argv

    self
  end

  # @return [Integer] as return code
  def run
    parse!

    Errno::NOERROR::Errno
  end
end
