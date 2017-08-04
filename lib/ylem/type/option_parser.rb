# frozen_string_literal: true

require 'ylem/type'
require 'sys-proc'
require 'optparse'

class Ylem::Type::OptionParser < ::OptionParser
  # Version
  #
  # @return [String]
  def version
    [Ylem::VERSION,
     nil,
     Ylem.version_info[:license_header]].join("\n")
  end
end
