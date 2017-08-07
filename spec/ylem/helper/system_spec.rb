# frozen_string_literal: true

require 'ylem/helper/system'
require 'pathname'

describe Ylem::Helper::System do
  {
    path:         (1..42).to_a,
    progname:     [0],
    'progname=':  [1],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

[:etc, :root, :var, :sysconf].sort.each do |name|
  describe Ylem::Helper::System do
    let(:path) { build(:paths).random.to_s.gsub(/^\//, '') }
    let(:matchable) { %r{#{path}$} }

    context "#path(:#{name})" do
      it { expect(subject.path(name)).to be_a(Pathname) }
    end

    context "#path(:#{name}, path)" do
      it { expect(subject.path(name, path)).to be_a(Pathname) }
    end

    context "#path(:#{name}, path).to_s" do
      it { expect(subject.path(name, path).to_s).to match(matchable) }
    end
  end
end
