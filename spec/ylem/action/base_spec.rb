# frozen_string_literal: true

require 'ylem/action/base'
require 'ylem/helper/config'
require 'pathname'

describe Ylem::Action::Base do
  let(:subject) do
    config = Ylem::Helper::Config.new.defaults

    described_class.new(config)
  end

  {
    config:           [0],
    options:          [0],
    retcode:          [0],
    'dummy_outputs?': [0],
    execute:          [0],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
