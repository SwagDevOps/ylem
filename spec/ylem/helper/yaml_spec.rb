# frozen_string_literal: true

require 'ylem/helper/yaml'
require 'pathname'

local = {
  sample_config: "#{SAMPLES_DIR}/config/success.yml",
}

describe Ylem::Helper::Yaml do
  {
    parse: [1],
    parse_file: [1],
  }.each do |method, counts|
    counts.each do |n|
      it { expect(subject).to respond_to(method).with(n).arguments }
    end
  end

  context "#parse_file('#{local[:sample_config]}')" do
    let(:parsed) { subject.parse_file(local[:sample_config]) }

    it { expect(parsed).to be_a(Hash) }

    it { expect(parsed).to have_all_symbol_keys }
  end
end
