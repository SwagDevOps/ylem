# frozen_string_literal: true

$LOAD_PATH.unshift __dir__

if Pathname.new(__dir__).join('..', 'Gemfile.lock').file?
  require 'rubygems'
  require 'bundler'

  Bundler.setup(:default)
end

if 'development' == ENV['PROJECT_MODE']
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
