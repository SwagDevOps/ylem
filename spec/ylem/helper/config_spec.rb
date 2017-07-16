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
  build(:config_defaults).patterns.each do |k, regexp|
    context "#defaults[:#{k}]" do
      let(:defaults) { subject.defaults }

      it { expect(defaults[k].to_s).to match(regexp) }
    end
  end
end

describe Ylem::Helper::Config do
  context "#parse_file('%s')" % build(:config_paths).success do
    let(:parsed) do
      parsed_file = build(:config_paths).success

      subject.parse_file(parsed_file)
    end

    it { expect(parsed).to be_a(Hash) }

    build(:config_defaults).patterns.keys.each do |key|
      context "#parse_file[:#{key}]" do
        # all default keys ust be present in parsed result
        it { expect(parsed.keys).to include(key) }

        # atm config only paths are present in config
        it { expect(parsed[key]).to be_a(Pathname) }
      end
    end
  end
end
