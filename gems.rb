# frozen_string_literal: true

# ```sh
# bundle config set --local clean 'true'
# bundle config set --local path 'vendor/bundle'
# bundle install --standalone
# ```
source 'https://rubygems.org'

group :default do
  gem 'dotenv', '~> 2.7'
  gem 'dry-inflector', '~> 0.1'
  gem 'hash_dot', '~> 2.4'
  gem 'kamaze-version', '~> 1.0'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
end

group :development do
  { github: 'SwagDevOps/kamaze-project', branch: 'develop' }.tap do |options|
    gem(*['kamaze-project'].concat([options]))
  end

  gem 'listen', '~> 3.1'
  gem 'rake', '~> 13.0'
  gem 'rubocop', '~> 1.3'
  gem 'rugged', '~> 1.0'
  # repl ---------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
end

group :doc do
  gem 'github-markup', '~> 3.0'
  gem 'redcarpet', '~> 3.5'
  gem 'yard', '~> 0.9'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'sham', '~> 2.0'
end
