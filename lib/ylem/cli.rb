# frozen_string_literal: true

require 'ylem'
require 'ylem/concern/helper'
require 'optparse'

# CLI interface
class Ylem::Cli
  include Ylem::Concern::Helper

  attr_reader :argv
  attr_reader :arguments
  attr_reader :command

  def initialize(argv = ARGV)
    @argv = argv.clone
    @arguments = []
  end

  class << self
    include Ylem::Concern::Helper

    def run(*args, &block)
      self.new(*args, &block).run
    end

    # Get available (registered) commands
    #
    # @return [Array<Class>]
    def commands
      [
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

      opts.separator nil
      opts.separator subtext
    end
  end

  # Parse command arguments
  #
  # @return [self]
  def parse!
    parser.order!(argv)
    @arguments = argv.clone
    @command = arguments.shift

    self
  end

  # @return [Fixnum]
  def run
    parse!

    return run_command(command, arguments).to_i if command?(command)

    STDERR.puts(parser)
    Errno::EINVAL::Errno
  end

  # Get commanda indexed by command name/keyword
  #
  # @return [Hash]
  def commands
    classes = self.class.commands
    results = { }

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
    command = (command || nil).to_s.empty? ? nil : command

    command ? commands.keys.include?(command.to_sym) : false
  end

  protected

  def run_command(command, arguments)
    commands.fetch(command.to_sym).new(argv).run
  end

  # Subtext used in help
  #
  # @return [String]
  def subtext
    lines = ['Available commands are:']
    commands.each do |k, v|
      lines << '%s%s: %s' % [' '*4, k, v.to_s]
    end

    lines += [
      nil,
      ("See '#{$PROGRAM_NAME} {%s} --help' " % commands.keys.join('|') +
       'for more information on a specific command.')
    ]

    lines.join("\n")
  end
end
