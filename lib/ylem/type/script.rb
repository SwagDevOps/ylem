# frozen_string_literal: true

require 'ylem/type'
require 'pathname'

# Describe a script file
#
# mostly a simple specialization based on ``Pathname``
class Ylem::Type::Script < Pathname
  # @return [Boolean]
  def script?
    self.file? and self.executable? and self.readable?
  end
end
