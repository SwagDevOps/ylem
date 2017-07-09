# coding: utf-8
# frozen_string_literal: true
#
# see: https://gist.github.com/chetan/1827484

CLOBBER.include('doc/')

desc 'Generate documentation (using YARD)'
task doc: ['gem:gemspec'] do
  [:pathname, :yard, :securerandom].each { |req| require req.to_s }

  # internal task name
  tname = 'doc:build:%s' % SecureRandom.hex(4)
  # extra static files to be included (eg. FAQ)
  statics = Dir.glob(['README.*', 'README'])

  YARD::Rake::YardocTask.new(tname) do |t|
    t.files = Project.spec.require_paths.map do |path|
      Pathname.new(path).join('**', '*.rb').to_s
    end

    t.options = {
      false => ['--no-stats'],
      true  => [],
    }[ENV['RAKE_DOC_WATCH'].to_i.zero?] + [
      '-o', 'doc',
      '--protected',
      '--markup-provider=redcarpet',
      '--markup=markdown',
      '--charset', 'utf-8',
      '--title',
      '%s v%s' % [Project.name, Project.version_info[:version]],
    ]

    t.options += ['--files', statics.join(',')] unless statics.empty?
  end

  Rake::Task[tname].invoke

  proc do
    threads = []
    Dir.glob('doc/**/*.html').each do |f|
      threads << Thread.new do
        f = Pathname.new(f)
        s = f.read.gsub(/^\s*<meta charset="[A-Z]+-{0,1}[A-Z]+">/,
                        '<meta charset="UTF-8">')
        f.write(s)
      end
    end

    threads.map(&:join)
  end
end

namespace :doc do
  desc 'Watch documentation changes'
  task watch: ['gem:gemspec'] do
    require 'listen'

    options = {
      only: /\.rb$/,
      ignore: [
        %r{/\.#},
        /_flymake\.rb$/,
      ],
    }

    # ENV['LISTEN_GEM_DEBUGGING'] = '2'
    # rubocop:disable Lint/HandleExceptions
    begin
      paths = Project.spec.require_paths
      ptask = proc do
        env = { 'RAKE_DOC_WATCH' => '1' }

        sh(env, 'rake', 'doc', verbose: false)
      end

      if ptask.call
        listener = Listen.to(*paths, options) { ptask.call }
        listener.start

        sleep
      end
    rescue SystemExit, Interrupt
    end
    # rubocop:enable Lint/HandleExceptions
  end
end
