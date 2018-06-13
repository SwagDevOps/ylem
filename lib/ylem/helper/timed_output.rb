# frozen_string_literal: true

require_relative '../helper'
require_relative '../concern/output'

# Timed printer
#
# Print lines to defined outputs [``$sdtout``|``$stderr``]
# with lines prefixed with time (using monotonic clock)
class Ylem::Helper::TimedOutput
  include Ylem::Concern::Output

  attr_reader :printable

  def initialize
    @mutex = Mutex.new
    @quiet = false
    @started = time
  end

  # @return [Float]
  def elapsed
    (time - @started).freeze
  end

  # Print given message
  #
  # @param [String] message
  # @param [Hash] options
  # @return [self]
  def print(message, options = {})
    options = { to: :stdout }.merge(options)

    mutex.synchronize do
      printable = "[%<time>.06f] %<input>s\n" % {
        input: message.to_s.rstrip,
        time: self.time,
      }

      outputs.fetch(options.fetch(:to)).puts(printable)
    end

    self
  end

  # Set quiet
  #
  # @param [Boolean] quiet
  def quiet=(quiet)
    mutex.synchronize { @quiet = !!quiet }
  end

  def dummy_outputs?
    !!@quiet
  end

  # Time in elapsed since system boot
  #
  # @see https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
  # @return [Float]
  def time
    timer = -> { Process.clock_gettime(Process::CLOCK_MONOTONIC) }

    yield(timer.call) if block_given?

    timer.call
  end

  protected

  # @return [Mutex]
  attr_reader :mutex
end
