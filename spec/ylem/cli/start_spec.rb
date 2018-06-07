# frozen_string_literal: true

require 'ylem/cli/start'

describe Ylem::Cli::Start, :cli, :'cli/start' do
  let(:subject) do
    described_class.new(['-c', sham!(:config_paths).success]).parse!
  end

  describe '.config' do
    it { expect(subject.config).to be_a(Hash) }
  end
end
