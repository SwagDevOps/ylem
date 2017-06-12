# frozen_string_literal: true

require 'ylem/helper/config'
require 'ylem/type/script'

# Class intended to list scripts (executables)
#
# List items from a defined path
class Ylem::Helper::Config::ScriptsLister
  include Ylem::Type

  # @return [Pathname|nil]
  def path
    Pathname.new(@path) if @path
  end

  # Configure instance
  #
  # @param [Hash] options
  # @return [self]
  def configure(options = {})
    @path = options[:path] if options.key?(:path)

    self
  end

  # List entries
  #
  # @return [Array<Pathname>]
  def entries
    Dir.glob('%s/*' % path).sort.map do |entry|
      Pathname.new(entry)
    end
  end

  # List scripts
  #
  # @return [Array<Pathname>]
  def scripts
    entries
      .map { |script| Script.new(script) }
      .map { |script| script if script.script? }
      .compact
  end
end
