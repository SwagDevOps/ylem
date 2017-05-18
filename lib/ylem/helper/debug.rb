# frozen_string_literal: true

require 'ylem/helper'

class Ylem::Helper::Debug
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
    require 'pp'
    begin
      require 'coderay'
      require 'pry/color_printer'
    rescue LoadError => e
      warn('%s: %s' % [caller[0], e.message])
    end

    args = [obj, out, width].compact
    colorable = (out.isatty and Kernel.const_defined?('Pry::ColorPrinter'))

    (colorable ? Pry::ColorPrinter : PP).pp(*args)
  end
end
