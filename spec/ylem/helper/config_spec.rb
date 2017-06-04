# frozen_string_literal: true

require 'ylem/helper/config'
require 'pathname'

config_defaults = {
  log_file:  /^\/var\/log\/(rake|rspec)\.log$/,
  scripts_dir: /^\/etc\/(rake|rspec)\/scripts$/,
  env_file: /^\/etc\/environment$/,
}

describe Ylem::Helper::Config do
  {
    defaults: [0],
    default_file: [0],
    parse_file: [0, 1],
    parse: [1],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  config_defaults.each do |k, regexp|
    context "#defaults[:#{k}]" do
      let(:defaults) { subject.defaults }

      it { expect(defaults[k].to_s).to match(regexp) }
    end
  end

  context '#default_file' do
    let(:default_file) { subject.default_file }

    it { expect(default_file).to be_a(Pathname) }

    # default value (example);
    # ``#<Pathname:/etc/progname/config.yml>``
    it do
      regexp = /^\/etc\/(rake|rspec)\/config\.yml$/

      expect(default_file.to_s).to match(regexp)
    end
  end

  context '#parse_file' do
    let(:parse_file) { subject.parse_file }

    it { expect(parse_file).to be_a(Hash) }

    config_defaults.keys.each do |key|
      it { expect(parse_file.keys).to include(key) }
    end
  end

  config_defaults.keys.each do |key|
    context "#parse_file[:#{key}]" do
      let(:parse_file) { subject.parse_file }

      it { expect(parse_file[key]).to be_a(Pathname) }
    end
  end
end