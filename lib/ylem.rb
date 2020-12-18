# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

# Base module (namespace)
module Ylem
  require 'English'
  autoload(:Pathname, 'pathname')

  class << self
    protected

    # @return [Boolean]
    def bundled?
      # @formatter:off
      [['gems.rb', 'gems.locked'], ['Gemfile', 'Gemfile.lock']]
        .map { |m| Dir.glob("#{__dir__}/../#{m}").size >= 2 }
        .include?(true)
      # @formatter:on
    end

    # @see https://bundler.io/man/bundle-install.1.html
    #
    # @return [Boolean]
    def standalone?
      standalone_setupfile.file?
    end

    def standalone!
      # noinspection RubyResolve
      standalone?.tap { |b| require standalone_setupfile if b }
    end

    # @api private
    #
    # @return [Pathname]
    def standalone_setupfile
      Pathname.new("#{__dir__}/../bundle/bundler/setup.rb")
    end
  end

  # @formatter:off
  {
    VERSION: 'version',
    Action: 'action',
    Cli: 'cli',
    Concern: 'concern',
    GC: 'gc',
    Helper: 'helper',
    Service: 'service',
    Type: 'type',
  }.each { |s, fp| autoload(s, Pathname.new(__dir__).join("ylem/#{fp}")) }
  # @formatter:on

  unless standalone!
    if bundled? # rubocop:disable Style/SoleNestedConditional
      require 'bundler/setup'

      if Gem::Specification.find_all_by_name('kamaze-project').any?
        require 'kamaze/project/core_ext/pp'
      end
    end
  end
end
