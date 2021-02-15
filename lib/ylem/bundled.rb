# frozen_string_literal: true

# Copyright (C) 3017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ylem'

# @see https://github.com/SwagDevOps/stibium-bundled
module Ylem::Bundled
  class << self
    autoload(:Pathname, 'pathname')
    autoload(:RbConfig, 'rbconfig')

    private

    BUNDLED_PATH = Pathname.new("#{__dir__}/../..").expand_path.freeze

    def included(othermod)
      begin
        require 'stibium/bundled'
      rescue LoadError
        load_stibium_bundled
      end

      othermod
        .__send__(:include, ::Stibium::Bundled)
        .__send__(:bundled_from, BUNDLED_PATH, setup: true, &bundle_handler)
    end

    # @return [Proc]
    def bundle_handler
      lambda do |bundle|
        if bundle.locked? and bundle.installed? and Object.const_defined?(:Gem)
          # rubocop:disable Style/SoleNestedConditional
          if bundle.specifications.keep_if { |s| s.name == 'kamaze-project' }.any?
            require 'kamaze/project/core_ext/pp'
          end
          # rubocop:enable Style/SoleNestedConditional
        end
      end
    end

    # @api private
    #
    # @return [Pathname]
    def load_stibium_bundled
      [
        [RUBY_ENGINE, RbConfig::CONFIG.fetch('ruby_version'), 'bundler/gems/*/stibium-bundled.gemspec'],
        [RUBY_ENGINE, RbConfig::CONFIG.fetch('ruby_version'), 'gems/stibium-bundled-*/lib/'],
      ].map { |parts| BUNDLED_PATH.join(*['{**/,}bundle'].concat(parts)) }.yield_self do |patterns|
        Pathname.glob(patterns).first&.dirname.tap { |gem_dir| require gem_dir.join('lib/stibium/bundled') }
      end
    end
  end
end
