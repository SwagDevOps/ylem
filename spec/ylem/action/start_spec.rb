# frozen_string_literal: true

require 'ylem/action/start'
require 'fileutils'

# execute a ``success`` action ---------------------------------------

describe Ylem::Action::Start do
  let!(:config) { build(:config_values).success }
  let!(:subject) { described_class.new(config) }
  before(:example) { FileUtils.rm_f(config.fetch(:'logger.file')) }

  context '#execute' do
    it { expect(subject.execute).to be_a(described_class) }

    context '.config.logger.file' do
      it { expect(subject.execute.config.logger.file).to be_file }
    end

    context '.retcode' do
      it { expect(subject.execute.retcode).to be_a(Integer) }
      it { expect(subject.execute.retcode).to be_zero }
    end
  end
end
