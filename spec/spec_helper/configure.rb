# frozen_string_literal: true

require 'pathname'
require 'sham'
require_relative 'local'

Sham::Config.activate!(Pathname.new(__dir__).join('..').realpath)

Object.class_eval { include Local }

require 'factory_bot'
FactoryGirl = FactoryBot

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.find_definitions

  def build(name)
    FactoryGirl.build(name)
  end
end
