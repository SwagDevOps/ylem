# frozen_string_literal: true

if File.file?("#{__dir__}/../Gemfile.lock")
  require 'rubygems'
  require 'bundler'

  Bundler.setup(:default)
end

$LOAD_PATH.unshift __dir__

if File.file?("#{__dir__}/../Gemfile.lock")
  if 'development' == ENV['PROJECT_MODE']
    require 'bundler/setup'

    def pp(*args)
      proc do
        require 'active_support/inflector'
        require 'ylem/helper/debug'

        ActiveSupport::Inflector.constantize('Ylem::Helper::Debug')
      end.call.new.dump(*args)
    end
  end
end

# Base module (namespace)
module Ylem
  require 'ylem/concern/versionable'

  include Concern::Versionable
end
