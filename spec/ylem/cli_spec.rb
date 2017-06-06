# frozen_string_literal: true

require 'ylem/cli'

describe Ylem::Cli do
  # instance methods
  {
    argv: [0],
    arguments: [0],
    parser: [0],
    commands: [0],
    'command?' => [1]
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
