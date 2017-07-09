# frozen_string_literal: true

require 'ylem/helper'
require 'ylem/concern/helper'
require 'tty/screen'

# Provides color printer automagically
class Ylem::Helper::Debug
  include Ylem::Concern::Helper

  # Outputs obj to out in pretty printed format of width columns in width.
  #
  # If out is omitted, ``STDOUT`` is assumed.
  # If width is omitted, ``79`` is assumed.
  #
  # @param [Object] obj
  # @param [IO] out
  # @param [Fixnum] width
  # @see http://ruby-doc.org/stdlib-2.2.0/libdoc/pp/rdoc/PP.html
  def dump(obj, out = STDOUT, width = nil)
    width ||= TTY::Screen.new.width || 79
    printer = out.isatty ? 0 : 1

    printers[printer].pp(obj, out, width)
  end

  # Get printers
  #
  # @return [Array]
  def printers
    printers_load

    [
      proc do
        target = 'Pry::ColorPrinter'

        Kernel.const_defined?(target) ? target : 'PP'
      end.call,
      'PP',
    ].map { |n| helper.get('inflector').constantize(n) }
  end

  protected

  # Load printers requirements (on demand)
  def printers_load
    require 'pp'

    begin
      require 'coderay'
      require 'pry/color_printer'
    rescue LoadError => e
      # rubocop:disable Performance/Caller
      warn('%s: %s' % [caller[0], e.message]) if @warned.nil?
      # rubocop:enable Performance/Caller
      @warned = true
    end

    self
  end
end
