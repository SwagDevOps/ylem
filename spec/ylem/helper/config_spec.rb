# frozen_string_literal: true

require 'ylem/helper/config'
require 'pathname'

describe Ylem::Helper::Config do
  {
    defaults: 0,
    default_file: 0,
    parse_file: 1,
    parse: 1,
  }.each do |method, n|
    it { expect(subject).to respond_to(method).with(n).arguments }
  end

  context '#default_file' do
    it { expect(subject.default_file).to be_a(Pathname) }

    # default value (example);
    # ``#<Pathname:/etc/progname/config.yml>``
    it do
      reg = /^\/etc\/(rake|rspec)\/config\.yml$/

      expect(subject.default_file.to_s).to match(reg)
    end
  end
end
