# frozen_string_literal: true

# Copyright (C) 3017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

autoload(:Pathname, 'pathname')
autoload(:RbConfig, 'rbconfig')

if self.is_a?(Module)
  Pathname.new("#{__dir__}/../..").expand_path.yield_self do |basedir|
    begin
      require 'stibium/bundled'
    rescue LoadError
      [
        [RUBY_ENGINE, RbConfig::CONFIG.fetch('ruby_version'), 'bundler/gems/*/stibium-bundled.gemspec'],
        [RUBY_ENGINE, RbConfig::CONFIG.fetch('ruby_version'), 'gems/stibium-bundled-*/lib/'],
      ].map { |parts| basedir.join(*['{**/,}bundle'].concat(parts)) }.yield_self do |patterns|
        Pathname.glob(patterns).first&.dirname.tap { |gem_dir| require gem_dir.join('lib/stibium/bundled') }
      end
    end

    self.__send__(:include, ::Stibium::Bundled).bundled_from(basedir, setup: true) do |bundle|
      if bundle.locked? and bundle.installed? and Object.const_defined?(:Gem)
        # rubocop:disable Style/SoleNestedConditional
        require 'kamaze/project/core_ext/pp' if bundle.specifications.keep_if { |s| s.name == 'kamaze-project' }.any?
        # rubocop:enable Style/SoleNestedConditional
      end
    end
  end
end
