# frozen_string_literal: true

require 'ylem/type'
require 'pathname'
require 'ylem/concern/helper'

# Describe a script file
#
# mostly a simple specialization based on ``Pathname``
class Ylem::Type::Script < Pathname
  include Ylem::Concern::Helper

  # Denote is a script (executable file)
  #
  # @return [Boolean]
  def script?
    self.file? and self.executable? and self.readable?
  end

  # Execute itself
  #
  # Script is responsible to execute itself, executing a non-executable or
  # inexistent script SHOULD return a ``127`` status
  #
  # @param [Hash] options
  # @option options [Ylem::Service::Logger] :logger
  # @option options [Symbol|String] :as
  #   method applied on instance (example: ``:basename``)
  #   identify itself with ``logger``
  #
  # @return [Fixnum]
  def execute(options = {})
    subprocess = helper.get('subprocess')
    # options processing
    as = options[:as] ? self.public_send(options.fetch(:as)) : self
    logger = options[:logger]&.as(as)

    subprocess.run([self], logger: logger).to_i
  end
end
