# frozen_string_literal: true

require 'factory_girl'
require 'hashie'
require 'rspec/sleeping_king_studios/matchers/core/all'
require '%s/../lib/%s' % [__dir__, ENV.fetch('PROJECT_NAME')]
require 'sys/proc'
require 'pathname'

Sys::Proc.progname = nil

# Constants ----------------------------------------------------------

SPEC_DIR = Pathname.new('spec')
SAMPLES_DIR = SPEC_DIR.join('..', 'samples')

# Matchers -----------------------------------------------------------

# Sample of use:
#
# ````
# it { expect(described_class).to define_constant(constant) }
# ````
RSpec::Matchers.define :define_constant do |const|
  match do |subject|
    subject.const_defined?(const)
  end
end

# Sample of use:
#
# ````
# it { expect(parsed).to have_all_symbol_keys }
# ````
#
# @see https://relishapp.com/rspec/rspec-expectations/v/2-4/docs/built-in-matchers/predicate-matchers#should-not-have-all-string-keys-(based-on-custom-#has-all-string-keys?-method)
RSpec::Matchers.define :have_all_symbol_keys do
  match do |subject|
    subject.keys.all? { |k| Symbol === k }
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # Generic struct (ala OpenStruct) based on Hashie
  class FactoryStruct < Hash
    include Hashie::Extensions::MethodAccess
  end

  FactoryGirl.find_definitions

  # Build is defined on a root level to be available outside of examples
  def build(name)
    FactoryGirl.build(name)
  end
end
