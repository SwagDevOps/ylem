# frozen_string_literal: true

require_relative '../type'
require 'optparse'

# Base option parser
class Ylem::Type::OptionParser < ::OptionParser
  # Get version
  #
  # @return [String]
  def version
    [Ylem::VERSION,
     nil,
     Ylem::VERSION.license_header].join("\n")
  end
end
