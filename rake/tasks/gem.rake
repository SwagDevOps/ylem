# frozen_string_literal: true

require 'cliver'

CLOBBER.include('pkg')

desc 'Build all the packages'
task gem: ['gem:gemspec', 'gem:package']

namespace :gem do
  # desc Rake::Task[:gem].comment
  task package: FileList.new('gem:gemspec', 'lib/**/*.rb') do
    require 'rubygems/package_task'
    require 'securerandom'

    # internal namespace name
    ns = '_%s' % SecureRandom.hex(4)
    namespace ns do
      task = Gem::PackageTask.new(Project.spec)
      task.define
      # Task management
      begin
        Rake::Task['%s:package' % ns].invoke
      rescue Gem::InvalidSpecificationException => e
        STDERR.puts(e)
        exit 1
      end
      Rake::Task['clobber'].reenable
    end
  end

  if Project.spec&.executables.size > 0 and Cliver.detect(:rubyc)
    CLOBBER.include('build')

    desc 'compile executables'
    task compile: ['gem:package'] do
      curdir = Pathname.new('.').realpath
      pkgdir = "pkg/#{Project.name}-#{Project.version_info[:version]}"
      srcdir = 'build/src'
      bindir = 'build/bin'
      tmpdir = 'build/tmp'

      Bundler.with_clean_env do
        rm_rf(srcdir)
        [srcdir, bindir, tmpdir].each { |dir| mkdir_p(dir) }
        cp_r(Dir.glob("#{pkgdir}/*"), srcdir)
        cp(Dir.glob("*.gemspec") + ['Gemfile'], srcdir)

        Dir.chdir(srcdir) do
          sh(Cliver.detect!(:bundle), 'install',
             '--path', 'vendor/bundle', '--clean',
             '--without', 'development', 'doc', 'test')

          Project.spec.executables.each do |executable|
            sh(Cliver.detect!(:rubyc),
               "#{Project.spec.bindir}/#{executable}",
               '-d', "#{curdir}/#{tmpdir}",
               '-r', "#{curdir}/#{srcdir}",
               '-o', "#{curdir}/#{bindir}/#{executable}")
            sh('strip', '-s', "#{curdir}/#{bindir}/#{executable}")
          end
        end
      end
    end
  end

  desc 'Update gemspec'
  task gemspec: "#{Project.name}.gemspec"

  desc 'Install gem'
  task install: ['gem:package'] do
    require 'cliver'

    sh(*[Cliver.detect(:sudo),
         Cliver.detect!(:gem),
         :install,
         Project.gem].compact.map(&:to_s))
  end

  # @see http://guides.rubygems.org/publishing/
  # @see rubygems-tasks
  #
  # Code mostly base on gem executable
  desc 'Push gem up to the gem server'
  task push: ['gem:package'] do
    ['rubygems',
     'rubygems/gem_runner',
     'rubygems/exceptions'].each { |i| require i }

    args = ['push', Project.gem]
    begin
      Gem::GemRunner.new.run(args.map(&:to_s))
    rescue Gem::SystemExitException => e
      exit e.exit_code
    end
  end
end
