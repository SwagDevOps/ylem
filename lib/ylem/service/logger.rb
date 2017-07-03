# frozen_string_literal: true

require 'ylem/service'
require 'logger'

# This creates Logger
#
# Sample of use:
#
# ```
# service.get{'logger')
#        .configure(file: STDOUT, level: Logger::INFO)
#        .warn('Nothing to do!')
# ```
#
# Logger tries to have a single instance by a given output (``file``)
class Ylem::Service::Logger
  attr_reader :id

  def initialize
    @instances = {}
    @id
  end

  # Configure an actual ``Logger``
  #
  # @param [Hash] options
  # @return [self]
  def configure(options)
    output = options.delete(:file) if options[:file]
    @id    = output.to_s

    unless @instances[id]
      @instances[id] = make_logger(output, options)
    end

    self
  end

  # Set output
  #
  # @return [self]
  def to(output)
    @id = output.to_s

    self
  end

  def method_missing(method, *args)
    super unless respond_to_missing?(method)

    instance.public_send(method, *args)
  end

  def respond_to_missing?(method, include_all = false)
    instance.respond_to?(method, include_all)
  end

  protected

  # Get instance
  #
  # @return [Logger]
  def instance
    instance = @instances[id]

    raise "no configuration for #{id}" if instance.nil?

    instance
  end

  # Get a preconfigured instance of Logger
  #
  # @param [Object] output
  # @return [Logger]
  def make_logger(output, options)
    logger          = Logger.new(output, 10, 1_024_000)
    logger.progname = Sys::Proc.progname

    # apply options
    logger = apply_level_on_logger(options[:level], logger)

    logger.formatter = proc do |severity, datetime, progname, msg|
      Logger::Formatter.new
                       .call(severity, datetime, progname, msg.dump)
    end

    logger
  end

  # Apply level on a ``::Logger`` instance
  #
  # @param [nil|Integer|String|Symbol] level
  # @param [::Logger]
  # @return [::Logger]
  def apply_level_on_logger(level, logger)
    level = Logger::INFO if level.nil?
    level = Logger.const_get(level.to_s.upcase) unless level.is_a?(Integer)

    logger.level = level

    logger
  end
end
