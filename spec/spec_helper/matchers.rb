# frozen_string_literal: true

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
RSpec::Matchers.define :have_all_symbol_keys do
  match do |subject|
    subject.keys.all? { |k| k.is_a?(Symbol) }
  end
end
