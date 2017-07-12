# frozen_string_literal: true

require 'ylem/cli'
require 'ylem/concern/helper'
require 'ylem/concern/action'
require 'ylem/concern/cli/output'
require 'etc'
require 'optparse'
require 'pathname'
# @see https://github.com/rails/rails/blob/master/activerecord/lib/active_record/base.rb
# @see http://api.rubyonrails.org/classes/ActiveSupport/DescendantsTracker.html
require 'active_support/descendants_tracker'

# @abstract Base command
class Ylem::Cli::Base
  attr_reader :argv
  attr_reader :options
  attr_reader :arguments

  extend ActiveSupport::DescendantsTracker
  include Ylem::Concern::Action
  include Ylem::Concern::Helper
  include Ylem::Concern::Cli::Output

  class << self
    include Ylem::Concern::Helper

    # Default options
    #
    # @return [Hash]
    def defaults
      {
        config_file: helper.get('config').default_file,
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
    @argv      = argv.clone
    @options   = self.class.defaults
    @arguments = []
  end

  # @return [OptionParser]
  def parser
    (options = @options).merge!(use_defaults: true)

    OptionParser.new do |opts|
      opts.banner = self.class.banner

      opts.on('-c=CONFIG',
              '--config=CONFIG',
              'Config file used [%s]' % options[:config_file]) do |c|
        options.merge!(config_file: c, use_defaults: false)
      end
    end
  end

  # @raise [OptionParser::InvalidOption]
  # @return [self]
  def parse!
    argv = self.argv.clone

    parser.parse!(argv)

    @options   = @options
    @arguments = argv

    self
  end

  # @return [Integer] as return code
  def run
    begin
      parse!
    rescue OptionParser::InvalidOption
      output(parser, to: :stderr)

      return Errno::EINVAL::Errno
    end

    action.new(config, options).execute.retcode
  end

  # Read config
  #
  # @raise Errno::ENOENT
  # @raise Errno::EACCES
  # @return [Hash]
  def config
    config_file  = @options[:config_file]
    use_defaults = @options.delete(:use_defaults)

    begin
      helper.get('config').parse_file(config_file)
    rescue Errno::ENOENT => e
      # Inexisting file, is not really an exception, unless user request
      raise unless use_defaults

      helper.get('config').defaults
    end
  end
end
