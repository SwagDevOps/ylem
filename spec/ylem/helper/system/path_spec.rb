# frozen_string_literal: true

require 'ylem/helper/system/path'
require 'pathname'

describe Ylem::Helper::System::Path do
  {
    rootdir:    [0],
    sysconfdir: [0],
    etcdir:     [0],
    vardir:     [0],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

describe Ylem::Helper::System::Path do
  {
    rootdir: '/',
    sysconfdir: '/etc',
    etcdir: '/etc',
    vardir: '/var',
  }.each do |method, path|
    context "##{method}" do
      it { expect(subject.public_send(method)).to be_a(Pathname) }
      it { expect(subject.public_send(method)).to eq(Pathname.new(path)) }
    end
  end
end
