# -*- coding: utf-8 -*-

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