# frozen_string_literal: true

if Pathname.new(__dir__).join('..', 'Gemfile.lock').file?
  require 'rubygems'
  require 'bundler'

  Bundler.setup(:default)
end

$LOAD_PATH.unshift __dir__

if 'development' == ENV['PROJECT_MODE']
  require 'bundler/setup' if Kernel.const_defined?('Bundle')

  def pp(*args)
    proc do
      require 'active_support/inflector'
      require 'ylem/helper/debug'

      ActiveSupport::Inflector.constantize('Ylem::Helper::Debug')
    end.call.new.dump(*args)
  end
end

# Base module (namespace)
module Ylem
  require 'ylem/concern/versionable'

  include Concern::Versionable
end
