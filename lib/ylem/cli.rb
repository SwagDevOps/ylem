# frozen_string_literal: true

require 'ylem'
require 'ylem/concern/helper'
require 'ylem/concern/cli/output'
require 'optparse'

# CLI interface
class Ylem::Cli
  include Ylem::Concern::Helper
  include Ylem::Concern::Cli::Output

  attr_reader :argv
  attr_reader :arguments
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
    # Usable, in place of:
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
    def run(argv)
      self.new(argv).run
    end

    # Get available (registered) commands
    #
    # @return [Array<Ylem::Cli::Base>]
    def commands
      [
        :dump,
        :start,
      ].map do |name|
        helper.get(:inflector).resolve("ylem/cli/#{name}")
      end
    end
  end

  def parser
    # Get an option parser
    #
    # @return OptionParser
    OptionParser.new do |opts|
      opts.banner = 'Usage: %s {%s} [options]' % [
        $PROGRAM_NAME,
        commands.keys.join('|'),
      ]

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
    begin
      parse!
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument
      output(parser, to: :stderr)

      return helper.get(:errno).retcode_get(:EINVAL)
    end

    run_command(command, arguments).to_i
  end

  # Get commanda indexed by command name/keyword
  #
  # @return [Hash]
  def commands
    classes = self.class.commands
    results = {}

    classes.each do |c|
      k = helper.get(:inflector).underscore(c.name.split('::')[-1])

      results[k.to_sym] = c
    end

    results
  end

  # Denote command is available (registered)
  #
  # @return [Boolean]
  def command?(command)
    command = command.to_s.empty? ? nil : command

    commands.keys.include?(command&.to_sym)
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
end
