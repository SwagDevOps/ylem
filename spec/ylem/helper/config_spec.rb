# frozen_string_literal: true

require 'ylem/helper/config'

describe Ylem::Helper::Config do
  {
    defaults: 0,
    default_file: 0,
    parse_file: 1,
    parse: 1,
  }.each do |method, n|
    it { expect(described_class.new).to respond_to(method).with(n).arguments }
  end
end
