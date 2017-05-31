# frozen_string_literal: true

require 'ylem/cli'
require 'ylem/concern/helper'
require 'ylem/concern/action'
require 'etc'
require 'optparse'
require 'pathname'
# @see https://github.com/rails/rails/blob/master/activerecord/lib/active_record/base.rb
# @see http://api.rubyonrails.org/classes/ActiveSupport/DescendantsTracker.html
require 'active_support/descendants_tracker'

# Base command (almost an abstract class)
class Ylem::Cli::Base
  attr_reader :argv
  attr_reader :options
  attr_reader :arguments

  extend ActiveSupport::DescendantsTracker
  include Ylem::Concern::Action

  class << self
    include Ylem::Concern::Helper

    # Default options
    #
    # @return [Hash]
    def defaults
      {
        config_file: helper.get('config').default_file
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

      'Usage: %s %s [options]' % [helper.get('system').progname, keyword]
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
              'Config file used [%s]' % options[:config_file]) do |c|
        options[:config_file] = c
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
