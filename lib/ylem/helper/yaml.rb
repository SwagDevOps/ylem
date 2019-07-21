# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../helper'

# Yaml helper built on top of ``YAML`
class Ylem::Helper::Yaml
  autoload(:JSON, 'json')
  autoload(:YAML, 'yaml')
  autoload(:Pathname, 'pathname')
  autoload(:ERB, 'erb')

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
    Pathname.new(filepath).read.tap do |content|
      # @see https://github.com/rails/rails/blob/b9ca94caea2ca6a6cc09abaffaad67b447134079/railties/lib/rails/application.rb#L226
      ERB.new(content).tap do |renderer|
        return parse(renderer.result)
      end
    end
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
