# frozen_string_literal: true

require 'ylem/helper/config/scripts_lister'
require 'pathname'
require 'securerandom'

local = {
  scripts_dir: "#{SPEC_DIR}/samples/scripts",
  random_dir: "#{SPEC_DIR}/samples/%s" % SecureRandom.hex(16),
  entries_size: 1,
  scripts_size: 1,
}

describe Ylem::Helper::Config::ScriptsLister do
  let(:subject) do
      described_class.new.configure(path: local.fetch(:scripts_dir))
  end

  context '#entries' do
    it { expect(subject.entries).to be_a(Array) }
  end

  context '#entries.size' do
    it { expect(subject.entries.size).to be(local.fetch(:entries_size)) }
  end

  context '#entries (using a random unexisting directory)' do
    let(:subject) do
      described_class.new.configure(path: local.fetch(:random_dir))
    end

    it { expect(subject.entries).to be_a(Array) }

    it { expect(subject.entries).to be_empty }
  end
end
