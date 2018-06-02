# frozen_string_literal: true

# bundle install --path vendor/bundle
source 'https://rubygems.org'

group :default do
  gem 'activesupport', '~> 5.1'
  gem 'version_info', '~> 1.9'
  gem 'sys-proc', '~> 1.0'
  gem 'hash_dot', '~> 2.1'
  gem 'dotenv', '~> 2.2'
end

group :development do
  gem 'rake', '~> 12.0'
  gem 'listen', '~> 3.1'
  gem 'pry', '~> 0.10'
  gem 'cliver', '= 0.3.2'
  gem 'rubocop', '~> 0.49'
  gem 'gemspec_deps_gen', '= 1.1.2'
  gem 'tenjin', '~> 0.7'
  gem 'rainbow', '~> 2.2'
  gem 'tty-editor', '~> 0.2'
  gem 'tty-screen', '~> 0.5'
  gem 'benchmark-memory', '~> 0.1'
end

group :development, :doc do
  gem 'yard', '~> 0.9'
  # Github Flavored Markdown in YARD
  gem 'redcarpet', '~> 3.4'
  gem 'github-markup', '~> 1.6'
end

group :development, :test do
  gem 'rspec', '~> 3.6'
  gem 'factory_girl', '~> 4.8'
  gem 'hashie', '~> 3.5'
end
