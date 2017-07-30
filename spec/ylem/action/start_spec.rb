# frozen_string_literal: true

require 'ylem/action/start'
require 'fileutils'

# execute a ``success`` action ---------------------------------------

{ success: 0, failure: 131 }.each do |config_type, retcode|
  describe Ylem::Action::Start do
    let!(:config) { build(:config_values).public_send(config_type) }
    let!(:subject) { described_class.new(config) }

    before(:example) do
      logfile = config.fetch(:'logger.file')

      FileUtils.mkdir_p(logfile.dirname)
      FileUtils.rm_f(logfile)
    end

    context '#execute' do
      it { expect(subject.execute).to be_a(described_class) }

      context '.retcode' do
        it { expect(subject.execute.retcode).to be_a(Integer) }
        it { expect(subject.execute.retcode).to be(retcode) }
      end

      context '.config.logger.file' do
        it { expect(subject.execute.config.logger.file).to be_file }
      end
    end
  end
end
