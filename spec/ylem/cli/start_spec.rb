# frozen_string_literal: true

require 'ylem/cli/start'
require 'ostruct'

describe Ylem::Cli::Start do
  let(:subject) do
    described_class.new(['-c', build(:config_paths).success]).parse!
  end

  describe '.config' do
    it { expect(subject.config).to be_a(Hash) }
  end
end
