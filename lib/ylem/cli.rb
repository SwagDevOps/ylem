# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
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
    @argv      = argv.clone
    @arguments = []
  end

  class << self
    include Ylem::Concern::Helper

    # Run, almost a shortcut
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
    # @see Ylem::Cli#initialize
    # @see Ylem::Cli#run
    def run(argv = ARGV)
      self.new(argv).run
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
        progname: $PROGRAM_NAME,
        commands: commands.keys.join('|'),
      }

      opts.separator(nil)
      opts.separator(subtext)
    end
  end

  # Parse command arguments
  #
  # @raise OptionParser::InvalidArgument
  # @return [self]
  def parse!
    parser.order!(argv)
    @arguments = argv.clone
    @command   = arguments.shift

    raise OptionParser::InvalidArgument unless command?(command)

    self
  end

  # @return [Fixnum]
  def run
    parse { run_command(command, arguments).to_i }
  end

  # Get commanda indexed by command name/keyword
  #
  # @return [Hash]
  def commands
    results = {}

    self.class.commands.each do |name|
      results[name.to_sym] = command_get(name)
    end

    results
  end

  # Denote command is available (registered)
  #
  # @return [Boolean]
  def command?(command)
    command = command.to_s.empty? ? nil : command

    command.nil? ? false : commands.key?(command.to_sym)
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
            "See '#{$PROGRAM_NAME} [command] --help'",
            'to read about a specific subcommand.')
      .join("\n")
  end

  # Format a command summary (as displayed in help)
  #
  # @param [Symbol] name
  # @return [String]
  def format_command_summary(name)
    padding = commands.keys.max_by(&:length).size + 4
    spacer  = ' ' * (padding - name.to_s.size)
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
