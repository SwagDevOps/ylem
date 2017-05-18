# frozen_string_literal: true

$LOAD_PATH.unshift __dir__

if 'development' == ENV['PROJECT_MODE']
  require 'rubygems'
  require 'bundler/setup'

  def pp(*args)
    proc do
      require 'active_support/inflector'
      require 'ylem/helper/debug'

      ActiveSupport::Inflector.constantize('Ylem::Helper::Debug')
    end.call.new.dump(*args)
  end
end

module Ylem
  require 'ylem/concern/versionable'

  include Concern::Versionable
end
