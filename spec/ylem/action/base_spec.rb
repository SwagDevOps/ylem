# frozen_string_literal: true

require 'ylem/action/base'

describe Ylem::Action::Base do
  let(:subject) do
    config = build(:helper_config).defaults

    described_class.new(config)
  end

  {
    config:            [0],
    options:           [0],
    arguments:         [0],
    retcode:           [0],
    'dummy_outputs?':  [0],
    'success?':        [0],
    execute:           [0],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
