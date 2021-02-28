# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../subprocess'
require 'timeout'

# Manage signals on given process.
#
# Tranmit signals to given ``external`` process.
class Ylem::Helper::Subprocess::Manager
  # @param [Process::Waiter] external
  # @param [Integer|Float] timeout
  def initialize(external, timeout = 10)
    @external = external
    @timeout = timeout.to_f

    manage_signals
  end

  protected

  # @return [Process::Waiter]
  #
  # @see https://ruby-doc.org/core-2.3.0/Thread.html
  # @see https://ruby-doc.org/core-2.3.0/Process/Waiter.html
  attr_accessor :external

  # @return [Float]
  attr_reader :timeout

  # Manage given signals.
  #
  # @return [self]
  def manage_signals(signals = ['INT', 'TERM', 'QUIT'])
    signals.each { |signal| trap_signal(signal) }

    self
  end

  # Trap given signal.
  #
  # @raise [SystemExit]
  def trap_signal(signal)
    Signal.trap(signal) do
      warn("signal: #{signal}")
      begin
        exit(0) if terminate
      rescue Timeout::Error => e
        warn(e.message)
        kill(:SIGKILL)
        exit(Errno::ETIME::Errno) # 62
      end
    end
  end

  # Terminate children process with ``SIGTERM``.
  #
  # @raise [Timeout::Error]
  def terminate
    Timeout.timeout(timeout) do
      loop do
        break if kill(:SIGTERM)

        sleep(0.25)
      end
    end

    true
  end

  # Kill children process with given signal.
  #
  # @return [Boolean]
  def kill(signal)
    Process.kill(signal, external.pid)
    Process.getpgid(external.pid)
  rescue Errno::ESRCH
    return true
  end
end
