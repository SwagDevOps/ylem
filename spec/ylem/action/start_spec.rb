# frozen_string_literal: true

require 'ylem/action/start'
require 'fileutils'

describe Ylem::Action::Start, :action, :'action/start' do
  let(:config) { sham!(:config_values).success }
  let(:subject) { described_class.new(config, [], quiet: true) }

  [:command, :'command?'].each do |method|
    it { expect(subject).to respond_to(method).with(0).arguments }
  end
end

# execute a ``success`` action ---------------------------------------

{ success: 0, failure: 131 }.each do |config_type, retcode|
  describe Ylem::Action::Start do
    let!(:config) { sham!(:config_values).public_send(config_type) }
    let!(:subject) { described_class.new(config, [], quiet: true) }

    before(:example) do
      logfile = config.fetch(:'logger.file')

      FileUtils.mkdir_p(logfile.dirname)
      FileUtils.rm_f(logfile)
    end

    context '#execute' do
      it { expect(subject.execute).to be_a(described_class) }
    end

    context '#execute.retcode' do
      it { expect(subject.execute.retcode).to be_a(Integer) }
      it { expect(subject.execute.retcode).to be(retcode) }
    end

    context '#execute.config.logger.file' do
      it { expect(subject.execute.config.logger.file).to be_file }
    end
  end
end
