# -*- coding: utf-8 -*-

require 'factory_girl'
require 'rspec/sleeping_king_studios/matchers/core/all'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  FactoryGirl.find_definitions

  # Build is defined on a root level to be available outside of examples
  def build(name)
    FactoryGirl.build(name)
  end
end
