# frozen_string_literal: true

require 'ylem/action/start'
require 'fileutils'

# instance methods ---------------------------------------------------

describe Ylem::Action::Start, :action, :'action/start' do
  let(:config) { sham!(:config_values).success }
  let(:subject) { described_class.new(config, [], quiet: true) }

  it { expect(subject).to respond_to(:command).with(0).arguments }
  it { expect(subject).to respond_to(:command?).with(0).arguments }
  it { expect(subject).to respond_to(:scripts).with(0).arguments }
  it { expect(subject).to respond_to(:success?).with(0).arguments }
  it { expect(subject).to respond_to(:keep_going?).with(0).arguments }
  it { expect(subject).to respond_to(:execute).with(0).arguments }
end

# execute ``success`` + ``failure`` actions --------------------------

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
