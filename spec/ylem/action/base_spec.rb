# frozen_string_literal: true

require 'ylem/action/base'

describe Ylem::Action::Base, :action, :'action/base' do
  let(:subject) do
    config = sham!(:helper_config).defaults

    described_class.new(config)
  end

  it { expect(subject).to respond_to(:config).with(0).arguments }
  it { expect(subject).to respond_to(:options).with(0).arguments }
  it { expect(subject).to respond_to(:arguments).with(0).arguments }
  it { expect(subject).to respond_to(:retcode).with(0).arguments }
  it { expect(subject).to respond_to(:dummy_outputs?).with(0).arguments }
  it { expect(subject).to respond_to(:success?).with(0).arguments }
  it { expect(subject).to respond_to(:execute).with(0).arguments }
end
