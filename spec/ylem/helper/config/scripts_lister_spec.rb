# frozen_string_literal: true

require 'ylem/helper/config/scripts_lister'
require 'pathname'
require 'securerandom'

local = {
  scripts_dir: "#{SAMPLES_DIR}/scripts",
  random_dirs: (1..10).to_a.map do |i|
    "#{SAMPLES_DIR}/#{SecureRandom.hex(16)}"
  end,
  entries_size: 2,
  scripts_size: 1,
}

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

describe Ylem::Helper::Config::ScriptsLister do
  let(:subject) do
    described_class.new.configure(path: local.fetch(:scripts_dir))
  end

  context '#path' do
    it { expect(subject.path).to exist }
  end

  context '#entries' do
    it { expect(subject.entries).to be_a(Array) }
  end

  context '#entries.size' do
    it { expect(subject.entries.size).to be(local.fetch(:entries_size)) }
  end
end

describe Ylem::Helper::Config::ScriptsLister do
  local.fetch(:random_dirs).each do |path|
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
