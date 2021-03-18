# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'

# CLI interface
class Ylem::Cli
  include Ylem::Concern::Helper
  include Ylem::Concern::Cli::Output
  include Ylem::Concern::Cli::Parse
  include Ylem::Concern::Cli::Progname

  # CLI argv
  #
  # @type [Array<String>]
  attr_reader :argv

  # Arguments
  #
  # @type [Array<String>]
  attr_reader :arguments

  # Command verb
  #
  # @return [Symbol]
  attr_reader :command

  # @param [Array] argv
  def initialize(argv = ARGV)
    @argv = argv.clone.dup.freeze.map(&:freeze)
    @arguments = []
  end

  class << self
    include Ylem::Concern::Helper

    # Shortcut for ``instance.run`` method>
    #
    # Usable, instead of:
    #
    # ```ruby
    # cli = Ylem::Cli.new(ARGV)
    # res = cli.run
    # ```
    #
    # @param [Array] argv
    # @return [Integer]
    #
    # @see #initialize
    # @see #run
    def call(argv = ARGV, progname: nil)
      self.new(argv).call(progname: progname)
    end

    # Get available (registered) commands
    #
    # @return [Array<Symbol>]
    def commands
      [
        :dump,
        :exec,
        :start,
      ]
    end
  end

  def parser
    # Get an option parser
    #
    # @return OptionParser
    Ylem::Type::OptionParser.new do |opts|
      opts.banner = 'Usage: %<progname>s {%<commands>s} [options]' % {
        progname: progname,
        commands: commands.keys.join('|'),
      }

      opts.separator(nil)
      opts.separator(subtext)
    end
  end

  # Parse command arguments
  #
  # @note Instance is frozen after arguments parsing.
  #
  # @raise OptionParser::InvalidArgument
  #
  # @return [self]
  def parse!
    -> { self.freeze }.tap do
      parser.order!(argv)

      @arguments = argv.dup.freeze.map(&:freeze)
      @command = arguments.shift.freeze

      raise OptionParser::InvalidArgument unless command?(command)
    end.call
  end

  # Execute cli and return status code.
  #
  # @return [Fixnum]
  def call(progname: nil)
    self.progname = progname unless progname.nil?

    parse { run_command(command, arguments).to_i }
  end

  # Get commanda indexed by command name/keyword
  #
  # @return [Hash{Symbol => Object}]
  def commands
    {}.tap do |results|
      self.class.commands.each do |name|
        results[name.to_sym] = command_get(name)
      end
    end
  end

  # Denote command is available (registered)
  #
  # @return [Boolean]
  def command?(command_name)
    (command_name.to_s.empty? ? nil : command_name).yield_self do |name|
      name.nil? ? false : commands.key?(name.to_sym)
    end
  end

  protected

  def run_command(command, arguments)
    commands.fetch(command.to_sym).new(arguments).run
  end

  # Subtext used in help
  #
  # @return [String]
  def subtext
    ['Available commands are:']
      .push(commands.keys.map { |k| format_command_summary(k) },
            nil,
            "See '#{progname} [command] --help'",
            'to read about a specific subcommand.')
      .join("\n")
  end

  # Format a command summary (as displayed in help)
  #
  # @param [Symbol] name
  # @return [String]
  def format_command_summary(name)
    padding = commands.keys.max_by(&:length).size + 4
    spacer = ' ' * (padding - name.to_s.size)
    summary = commands.fetch(name).summary

    "   #{name}#{spacer}#{summary}"
  end

  # Resolve command by name
  #
  # @param [String|Symbol] name
  # @return [Ylem::Cli::Base]
  def command_get(name)
    helper.get(:inflector).resolve("ylem/cli/#{name}")
  end
end
