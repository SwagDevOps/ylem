# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# @abstract Base command
class Ylem::Cli::Base
  # @return [Array]
  attr_reader :argv
  # @return [Hash]
  attr_reader :options
  # @return [Array]
  attr_reader :arguments

  include Ylem::Concern::Action
  include Ylem::Concern::Helper
  include Ylem::Concern::Cli::Output
  include Ylem::Concern::Cli::Parse

  class << self
    include Ylem::Concern::Helper

    # Default options
    #
    # @return [Hash]
    def defaults
      {
        config_file: helper.get(:config).default_file,
      }
    end

    # Summary
    #
    # A short description of the command
    # SHOULD be overriden by child class
    #
    # @return [String]
    def summary
      self.name
    end

    # Keyword used to identify command
    #
    # @return [String]
    def keyword
      helper.get(:inflector).underscore(name.split('::')[-1])
    end

    # Get banner
    #
    # @return [String]
    def banner
      'Usage: %<progname>s %<keyword>s [options]' % {
        progname: helper.get(:system).progname,
        keyword: keyword
      }
    end
  end

  # @param [Array] argv
  def initialize(argv = ARGV)
    @argv = argv.clone
    @options = self.class.defaults
    @arguments = []
  end

  # @return [OptionParser]
  def parser
    (options = @options).merge!(use_defaults: true)

    Ylem::Type::OptionParser.new do |opts|
      opts.banner = self.class.banner

      opts.on('-c=CONFIG',
              '--config=CONFIG',
              'Config file used [%<config_file>s]' % {
                config_file: options[:config_file]
              }) { |c| options.merge!(config_file: c, use_defaults: false) }
    end
  end

  # Parse options given through the command line arguments
  #
  # @raise [OptionParser::ParseError]
  # @return [self]
  def parse!
    self.tap do
      argv = self.argv.clone
      parser.parse!(argv)
      @arguments = argv.clone
    end
  end

  # @return [Integer] as return code
  def run
    parse { executable.execute.retcode }
  end

  # Read config
  #
  # @raise [Errno::ENOENT]
  # @raise [Errno::EACCES]
  # @return [Hash]
  def config
    config_file = @options[:config_file]
    use_defaults = @options.delete(:use_defaults)

    begin
      helper.get(:config).parse_file(config_file)
    rescue Errno::ENOENT
      # Inexisting file, is not really an exception, unless user request
      raise unless use_defaults

      helper.get(:config).defaults
    end
  end

  protected

  # Get an executable action (ready to go)
  #
  # @return [Ylem::Action::Base]
  def executable
    action.new(config, arguments, options)
  end
end
