# frozen_string_literal: true

require_relative '../subprocess'

# Wrapper around IO to avoid errors on ``stream closed``.
class Ylem::Helper::Subprocess::Streamer
  # @param [IO] stream
  def initialize(stream)
    @stream = stream
  end

  # @return [Boolean]
  def eof?
    stream.eof?
  rescue IOError => e
    raise(e) unless e.message =~ /stream closed/
    return true
  end

  def method_missing(method, *args)
    super unless respond_to?(method)

    stream.public_send(method, *args)
  end

  def respond_to_missing?(method, include_all = false)
    stream.respond_to?(method, include_all)
  end

  protected

  # @return [IO]
  attr_reader :stream
end
