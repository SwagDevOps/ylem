# frozen_string_literal: true

require 'ylem/service'
require 'sys/proc'
require 'logger'

# This creates ``::Logger`` instances, almost a kind of factory
#
# Sample of use:
#
# ```
# logger = service.get{'logger')
#                 .configure(file: STDOUT, level: debug)
#
# logger.debug('Using default logger')
# logger.as(:service).warn('Something bad is happening')
# ```
#
# Logger has a single instance for each identifier (``id``)
class Ylem::Service::Logger
  def initialize
    @instances = {}
    @options = {}
  end

  # Configure a``::Logger`` instance
  #
  # @raise [RuntimeError] when ``:file`` is missing in ``options``
  # @raise [RuntimeError] when already configured
  # @param [Hash] options
  # @return [self]
  def configure(options)
    raise ":file must be set, got: #{options}" unless options[:file]

    unless @options.empty?
      raise 'already configured' if options != @options
    end

    @options = options

    self
  end

  # Get an instance of ``::Logger`` identified by ``id``
  #
  # @param [String|Symbol|Object] id
  # @return [::Logger]
  def as(id)
    instance_by_id(id)
  end

  # Remove all instances
  #
  # @return [self]
  def purge
    @instances = {}

    self
  end

  # Reset, empty configuration and purge instances
  #
  # @return [self]
  def reset
    purge
    @options = {}

    self
  end

  def method_missing(method, *args)
    super unless respond_to_missing?(method)

    as(nil).public_send(method, *args)
  end

  def respond_to_missing?(method, include_all = false)
    as(nil).respond_to?(method, include_all)
  end

  protected

  # Get an instance designed by an ``id``
  #
  # @param [String|Symbol|Object] id
  # @return [Logger]
  def instance_by_id(id)
    id = id.to_s

    @instances[id] ||= proc do
      configure(@options)

      make_logger(@options.clone.merge(id: id.to_s.empty? ? nil : id))
    end.call

    @instances[id]
  end

  # Get a preconfigured instance of Logger
  #
  # @param [Object] output
  # @return [Logger]
  def make_logger(options)
    logger = Logger.new(options.fetch(:file), 10, 1_024_000)
    logger.progname = options.fetch(:id) || Sys::Proc.progname.upcase

    # apply options
    logger = apply_level_on_logger(options[:level], logger)

    logger.formatter = proc do |severity, datetime, progname, msg|
      Logger::Formatter
        .new
        .call(severity, datetime, progname, msg.dump)
    end

    logger
  end

  # Apply level on a ``::Logger`` instance
  #
  # @param [nil|Integer|String|Symbol] level
  # @param [::Logger] logger
  # @return [::Logger]
  def apply_level_on_logger(level, logger)
    level = Logger::INFO if level.nil?
    level = Logger.const_get(level.to_s.upcase) unless level.is_a?(Integer)

    logger.level = level

    logger
  end
end
