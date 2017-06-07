# frozen_string_literal: true

require 'ylem/cli/start'
require 'ostruct'

local = {
  sample_config: "#{SPEC_DIR}/samples/config.yml",
}

describe Ylem::Cli::Start do
  let(:subject) do
    described_class.new(['-c', local[:sample_config]]).parse!
  end

  it { expect(subject.config).to be_a(Hash) }
end
