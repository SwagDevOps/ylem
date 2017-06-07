# frozen_string_literal: true

require 'rspec/sleeping_king_studios/matchers/core/all'
require '%s/../lib/%s' % [__dir__, ENV.fetch('PROJECT_NAME')]
require 'sys/proc'
require 'pathname'

Sys::Proc.progname = nil

# Constants ----------------------------------------------------------

SPEC_DIR = Pathname.new('spec')

# Matchers -----------------------------------------------------------

# Sample of use:
#
# ~~~~
# it { expect(described_class).to define_constant(constant) }
# ~~~~
RSpec::Matchers.define :define_constant do |const|
  match do |subject|
    subject.const_defined?(const)
  end
end
