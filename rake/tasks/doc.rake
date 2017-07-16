# coding: utf-8
# frozen_string_literal: true
#
# see: https://gist.github.com/chetan/1827484

CLOBBER.include('doc/')

# Config ------------------------------------------------------------

ignored_patterns = [
  %r{/\.#},
  /_flymake\.rb$/,
]

# Tasks -------------------------------------------------------------

if (yardopts_file = Pathname.new(Dir.pwd).join('.yardopts')).file?
  desc 'Generate documentation (using YARD)'
  task doc: ['gem:gemspec'] do
    [:pathname, :yard, :securerandom].each { |req| require req.to_s }

    # internal task name
    tname = 'doc:t_%s' % SecureRandom.hex(8)

    YARD::Rake::YardocTask.new(tname) do |t|
      t.options = proc do
        require 'shellwords'

        Shellwords.split(yardopts_file.read) + [
          '--output-dir', './doc',
          '--title',
          '%s v%s' % [Project.name, Project.version_info[:version]]
        ]
      end.call + {
        false => ['--no-stats'],
        true  => [],
      }[ENV['RAKE_DOC_WATCH'].to_i.zero?]

      ignored_patterns.each do |regexp|
        t.options += ['--exclude', regexp.inspect.gsub(%r{^/|/$}, '')]
      end

      t.after = proc { Rake::Task['doc:after'].invoke }
    end

    Rake::Task[tname].invoke
  end

  namespace :doc do
    task :after do
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
  end

  namespace :doc do
    desc 'Watch documentation changes'
    task watch: ['gem:gemspec'] do
      require 'listen'

      options = {
        only:   /\.rb$/,
        ignore: ignored_patterns,
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
end
