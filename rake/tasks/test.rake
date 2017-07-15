# frozen_string_literal: true

# More convenient than ``bundle exec``
#
# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
# https://github.com/rspec/rspec-core/blob/master/lib/rspec/core/runner.rb

rspec_file = Pathname.new('.').join('.rspec')

if rspec_file.file?
  desc 'Run test suites'
  task :test, [:tag] do |task, args|
    # Extract options directly from ``.rspec`` file, consistent behavior
    options = proc do
      require 'shellwords'

      Shellwords.split(rspec_file.read)
    end.call

    proc do
      require 'rspec/core'

      options += ['--tag', args[:tag]] if args[:tag]
      status = RSpec::Core::Runner.run(options, $stderr, $stdout).to_i

      exit(status) unless status.zero?
    end.call
  end

  task spec: [:test]
end
