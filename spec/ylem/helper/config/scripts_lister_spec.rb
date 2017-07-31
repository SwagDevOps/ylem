# frozen_string_literal: true

require 'ylem/helper/config/scripts_lister'

describe Ylem::Helper::Config::ScriptsLister do
  {
    path: [0],
    configure: [0, 1],
    entries: [0],
    scripts: [0],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end

# using different configs --------------------------------------------

{ success: [1, 1], failure: [2, 2] }.each do |config_type, counts|
  describe Ylem::Helper::Config::ScriptsLister do
    let!(:config) { build(:config_values).public_send(config_type) }
    let!(:subject) do
      described_class.new
                     .configure(path: config.fetch(:'scripts.path'))
    end
    let!(:entries_size) { counts.fetch(0) }
    let!(:scrpts_size) { counts.fetch(1) }

    context '#path' do
      it { expect(subject.path).to exist }
    end

    context '#entries' do
      it { expect(subject.entries).to be_a(Array) }
    end

    context '#entries.size' do
      it { expect(subject.entries.size).to be(entries_size) }
    end

    context '#scripts' do
      it { expect(subject.scripts).to be_a(Array) }
    end

    context '#scripts.size' do
      it { expect(subject.scripts.size).to be(scrpts_size) }
    end
  end
end

# using 10 randomized unexisting directories -------------------------

(1..10).to_a.each do
  describe Ylem::Helper::Config::ScriptsLister do
    let(:path) { build(:paths).random }
    let(:subject) { described_class.new.configure(path: path) }

    context '#path' do
      # value as set during test initialization
      it { expect(subject.path).to eq(path) }
      # path should not exist
      it { expect(subject.path).to_not exist }
    end

    [:entries, :scripts].each do |method|
      context "##{method}" do
        it { expect(subject.public_send(method)).to be_a(Array) }

        it { expect(subject.public_send(method)).to be_empty }
      end
    end
  end
end
