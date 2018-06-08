# frozen_string_literal: true

require 'ylem/helper/system'
require 'pathname'

describe Ylem::Helper::System, :helper, :'helper/system' do
  it { expect(subject).to respond_to(:path).with(1).arguments }
  it { expect(subject).to respond_to(:path).with(42).arguments }

  it { expect(subject).to respond_to(:progname).with(0).arguments }
  it { expect(subject).to respond_to('progname=').with(1).arguments }
end

[:etc, :root, :var, :sysconf].sort.each do |name|
  describe Ylem::Helper::System, :helper, :'helper/system' do
    let(:path) { sham!(:paths).randomizer.call.to_s.gsub(%r{^/}, '') }
    let(:matchable) { %r{/#{path}$} }

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
