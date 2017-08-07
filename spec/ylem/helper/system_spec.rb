# frozen_string_literal: true

require 'ylem/helper/system'
require 'pathname'

describe Ylem::Helper::System do
  {
    path:         (1..42).to_a,
    progname:     [0],
    'progname=':  [1],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end
end
