# frozen_string_literal: true

require 'ylem/action/start'

# execute a ``success`` action ---------------------------------------

describe Ylem::Action::Start do
  let(:subject) do
    config = build(:config_values).success

    described_class.new(config)
  end

  context '#execute' do
    it { expect(subject.execute).to be_a(described_class) }
    context '.retcode' do
      let(:retcode) { subject.execute.retcode }

      it { expect(retcode).to be_a(Integer) }
      it { expect(retcode).to be_zero }
    end
  end
end
