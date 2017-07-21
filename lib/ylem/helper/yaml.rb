# frozen_string_literal: true

require 'ylem/helper'
require 'json'
require 'pathname'
require 'yaml'

# Yaml helper built on top of ``YAML`
class Ylem::Helper::Yaml
  # Parse Yaml source into a Ruby data structure
  #
  # @param [String] content
  # @return [Hash|Array|nil]
  def parse(content)
    parsed = engine.load(content)

    symbolize_hash(parsed) unless parsed.nil?
  end

  # Parse a Yaml file
  #
  # @param [String|Pathname] filepath
  # @return [Hash]
  def parse_file(filepath)
    content = Pathname.new(filepath).read

    parse(content)
  end

  protected

  # @return [YAML]
  def engine
    YAML
  end

  # Return symbols for the names (keys)
  #
  # @param [Hash] hash
  # @return [Hash]
  def symbolize_hash(hash)
    JSON.parse(hash.to_json, symbolize_names: true)
  end
end
