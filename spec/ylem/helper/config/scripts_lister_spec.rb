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

{ success: 1, failure: 2 }.each do |config_type, entries_size|
  describe Ylem::Helper::Config::ScriptsLister do
    let!(:config) { build(:config_values).public_send(config_type) }
    let!(:subject) do
      described_class.new
                     .configure(path: config.fetch(:'scripts.path'))
    end

    context '#path' do
      it { expect(subject.path).to exist }
    end

    context '#entries' do
      it { expect(subject.entries).to be_a(Array) }
    end

    context '#entries.size' do
      it { expect(subject.entries.size).to be(entries_size) }
    end
  end
end

describe Ylem::Helper::Config::ScriptsLister do
  build(:paths).random.each do |path|
    let(:subject) do
      described_class.new.configure(path: path)
    end

    context '#path' do
      it { expect(subject.path).to_not exist }
    end

    context '#entries (using a random unexisting directory)' do
      it { expect(subject.entries).to be_a(Array) }

      it { expect(subject.entries).to be_empty }
    end
  end
end
