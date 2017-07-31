# frozen_string_literal: true

require 'ylem/helper/config'
require 'pathname'

describe Ylem::Helper::Config do
  {
    defaults:     [0],
    default_file: [0],
    parse_file:   [0, 1],
    parse:        [1],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  context '#default_file' do
    let(:config_paths) { build(:config_paths) }
    let(:default_file) { subject.default_file }

    it { expect(default_file).to be_a(Pathname) }

    it { expect(default_file.to_s).to match(config_paths.default) }
  end
end

describe Ylem::Helper::Config do
  let(:defaults) { subject.defaults }
  let(:expected_keys) { build(:config_defaults).patterns.keys.sort }

  context '#defaults' do
    it { expect(defaults).to eq(build(:helper_config).defaults) }
  end

  context '#defaults.keys' do
    it { expect(defaults.keys.sort).to eq(expected_keys) }
  end

  build(:config_defaults).patterns.each do |k, regexp|
    context "#defaults[:#{k}]" do
      it { expect(defaults[k].to_s).to match(regexp) }
    end
  end
end

# testing with different type of config ------------------------------

describe Ylem::Helper::Config do
  [:success, :failure, :partial, :empty].map(&:to_s).each do |config_type|
    context "#parse_file('%s')" % build(:config_paths).fetch(config_type) do
      let(:parsed) do
        parsed_file = build(:config_paths).fetch(config_type)

        subject.parse_file(parsed_file)
      end

      it { expect(parsed).to be_a(Hash) }

      build(:config_defaults).patterns.keys.each do |key|
        context "#parse_file[:#{key}]" do
          let(:expected_class) { build(:config_defaults).types.fetch(key) }

          # all default keys MUST be present in parsed result
          it { expect(parsed.keys).to include(key) }

          it { expect(parsed[key]).to be_a(expected_class) }
        end
      end
    end
  end
end

# testing with an inexistent file ------------------------------------

describe Ylem::Helper::Config do
  context "#parse_file('%s')" % build(:config_paths).random do
    let(:parsed_file) { build(:config_paths).random }
    let(:error) { Errno::ENOENT }

    it { expect { subject.parse_file(parsed_file) }.to raise_error(error) }
  end
end
