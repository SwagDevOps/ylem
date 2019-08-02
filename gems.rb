# frozen_string_literal: true

# bundle install --path vendor/bundle
source 'https://rubygems.org'

group :default do
  gem 'dotenv', '~> 2.7'
  gem 'dry-inflector', '~> 0.1'
  gem 'hash_dot', '~> 2.4'
  gem 'kamaze-version', '~> 1.0'
  gem 'sys-proc', '~> 1.1'
end

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.72'

  group :repl do
    gem 'interesting_methods', '~> 0.1'
    gem 'pry', '~> 0.12'
    gem 'pry-coolline', '~> 0.2'
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
end
