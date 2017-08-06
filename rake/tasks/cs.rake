# frozen_string_literal: true
# A Ruby static code analyzer, based on the community Ruby style guide.
#
# @see http://batsov.com/rubocop/
# @see https://github.com/bbatsov/rubocop
#
# Share RuboCop rules across repos
# @see https://blog.percy.io/share-rubocop-rules-across-all-of-your-repos-f3281fbd71f8
# @see https://github.com/percy/percy-style
#
# ~~~~
# # .rubocop.yml
# inherit_gem:
#   percy-style: [ default.yml ]
# ~~~~

namespace :cs do
  require 'rubocop/rake_task'

  {
    control: {
      description: 'Run static code analyzer',
      options:     ['--fail-level', 'E'],
    },
    correct: {
      description: 'Run static code analyzer, auto-correcting offenses',
      options:     ['--fail-level', 'E', '--auto-correct'],
    }
  }.each do |name, meta|
    desc meta.fetch(:description)
    task name, [:path] => ['gem:gemspec'] do |t, args|
      paths = Project.spec.require_paths

      RuboCop::RakeTask.new('%s:rubocop' % t.name) do |task|
        task.options       = meta.fetch(:options)
        task.patterns      = args[:path] ? [args[:path]] : paths
        task.fail_on_error = true
      end

      Rake::Task['%s:rubocop' % t.name].invoke
    end
  end
end
