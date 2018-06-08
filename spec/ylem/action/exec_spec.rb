# frozen_string_literal: true

require 'ylem/action/exec'
require 'fileutils'

# execute an ``exec`` action -----------------------------------------

describe Ylem::Action::Exec, :action, :'action/exec' do
  let!(:config) { sham!(:config_values).success }
  # execute should fail, as we use a random path as command
  let!(:command) { [sham!(:paths).randomizer.call] }
  let!(:subject) { described_class.new(config, command, quiet: true) }

  before(:example) do
    logfile = config.fetch(:'logger.file')

    FileUtils.mkdir_p(logfile.dirname)
    FileUtils.rm_f(logfile)
  end

  it { expect(subject).to respond_to(:command).with(0).arguments }

  context '#execute' do
    it { expect(subject.execute).to be_a(described_class) }
  end

  (1..10).to_a.each do
    context '#command' do
      it { expect(subject.command).to be_a(Array) }
      it { expect(subject.command).to eq(command.compact.map(&:to_s)) }
    end

    context '#execute.retcode' do
      it { expect(subject.execute.retcode).to be_a(Integer) }
      it { expect(subject.execute.retcode).to be(Errno::ENOENT::Errno) }
    end
  end
end
